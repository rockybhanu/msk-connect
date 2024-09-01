resource "aws_cloudwatch_log_group" "msk_connect_log_group" {
  name = "/aws/mskconnect/debezium-postgres-connector" # Provide a meaningful name for the log group
}

resource "aws_mskconnect_connector" "debezium_postgres_connector" {
  name                 = "debezium-postgres-connector"
  kafkaconnect_version = "2.7.1"

  service_execution_role_arn = aws_iam_role.msk_connect_role.arn

  capacity {
    autoscaling {
      mcu_count        = 1
      min_worker_count = 1
      max_worker_count = 2

      scale_in_policy {
        cpu_utilization_percentage = 20
      }

      scale_out_policy {
        cpu_utilization_percentage = 80
      }
    }
  }

  connector_configuration = {
    "connector.class"                                                     = "io.debezium.connector.postgresql.PostgresConnector"
    "tasks.max"                                                           = "1"
    "database.hostname"                                                   = "postgres.ramanuj.dev"
    "database.port"                                                       = "30032"
    "database.user"                                                       = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)["username"]
    "database.password"                                                   = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)["password"]
    "database.dbname"                                                     = "crm"
    "database.server.name"                                                = "dbserver1"
    "database.whitelist"                                                  = "crm"
    "table.whitelist"                                                     = "public.customer_records"
    "database.history.kafka.bootstrap.servers"                            = aws_msk_cluster.ramanuj-dev.bootstrap_brokers_tls
    "database.history.kafka.topic"                                        = "schema-changes.crm"
    "include.schema.changes"                                              = "true"
    "snapshot.mode"                                                       = "initial"
    "transforms.unwrap.type"                                              = "io.debezium.transforms.ExtractNewRecordState"
    "transforms.unwrap.add.headers"                                       = "op"
    "key.converter.schemas.enable"                                        = "true"
    "value.converter.schemas.enable"                                      = "true"
    "schema.history.internal.kafka.bootstrap.servers"                     = aws_msk_cluster.ramanuj-dev.bootstrap_brokers_tls
    "schema.history.internal.consumer.security.protocol"                  = "SASL_SSL"
    "schema.history.internal.consumer.sasl.mechanism"                     = "AWS_MSK_IAM"
    "schema.history.internal.consumer.sasl.jaas.config"                   = "software.amazon.msk.auth.iam.IAMLoginModule required;"
    "schema.history.internal.consumer.sasl.client.callback.handler.class" = "software.amazon.msk.auth.iam.IAMClientCallbackHandler"
    "schema.history.internal.producer.security.protocol"                  = "SASL_SSL"
    "schema.history.internal.producer.sasl.mechanism"                     = "AWS_MSK_IAM"
    "schema.history.internal.producer.sasl.jaas.config"                   = "software.amazon.msk.auth.iam.IAMLoginModule required;"
    "schema.history.internal.producer.sasl.client.callback.handler.class" = "software.amazon.msk.auth.iam.IAMClientCallbackHandler"
    "request.timeout.ms"                                                  = "300000" # Increase the request timeout
    "retry.backoff.ms"                                                    = "50000"  # Increase the retry backoff time
  }

  kafka_cluster {
    apache_kafka_cluster {
      bootstrap_servers = aws_msk_cluster.ramanuj-dev.bootstrap_brokers_sasl_iam # Use directly if available as a string

      vpc {
        security_groups = [aws_security_group.msk_security_group.id]
        subnets         = [aws_subnet.msk_subnet[0].id, aws_subnet.msk_subnet[1].id]
      }
    }
  }

  kafka_cluster_client_authentication {
    authentication_type = "IAM" # Use IAM for secure authentication
  }

  kafka_cluster_encryption_in_transit {
    encryption_type = "TLS" # Use TLS encryption for secure communication
  }

  plugin {
    custom_plugin {
      arn      = aws_mskconnect_custom_plugin.ramanuj_dev.arn
      revision = aws_mskconnect_custom_plugin.ramanuj_dev.latest_revision
    }
  }

  log_delivery {
    worker_log_delivery {
      cloudwatch_logs {
        enabled   = true # Minimal logging to CloudWatch for basic inspection
        log_group = aws_cloudwatch_log_group.msk_connect_log_group.name
      }
    }
  }
}
