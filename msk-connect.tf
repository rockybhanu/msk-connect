resource "aws_mskconnect_custom_plugin" "example" {
  name         = "debezium-example"
  content_type = "ZIP"

  location {
    s3 {
      bucket_arn = aws_s3_bucket.example.arn
      file_key   = aws_s3_object.example.key
    }
  }
}

resource "aws_mskconnect_connector" "debezium_postgres_connector" {
  name                 = "debezium-postgres-connector"
  kafkaconnect_version = "2.7.1"

  service_execution_role_arn = "arn:aws:iam::123456789012:role/MSKConnectExecutionRole" # Replace with your IAM role ARN

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
    "connector.class"                          = "io.debezium.connector.postgresql.PostgresConnector"
    "tasks.max"                                = "1"
    "database.hostname"                        = "postgres.ramanuj.dev"
    "database.port"                            = "30032"
    "database.user"                            = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)["username"]
    "database.password"                        = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)["password"]
    "database.dbname"                          = "crm"
    "database.server.name"                     = "dbserver1"
    "database.whitelist"                       = "crm"
    "table.whitelist"                          = "public.customer_records"
    "database.history.kafka.bootstrap.servers" = aws_msk_cluster.example.bootstrap_brokers_tls
    "database.history.kafka.topic"             = "schema-changes.crm"
    "include.schema.changes"                   = "true"
    "snapshot.mode"                            = "initial"
    "transforms.unwrap.type"                   = "io.debezium.transforms.ExtractNewRecordState"
    "transforms.unwrap.add.headers"            = "op"
    "key.converter.schemas.enable"             = "true"
    "value.converter.schemas.enable"           = "true"
  }

  kafka_cluster {
    apache_kafka_cluster {
      bootstrap_servers = aws_msk_cluster.example.bootstrap_brokers_tls

      vpc {
        security_groups = [aws_security_group.msk_security_group.id]
        subnets         = [aws_subnet.msk_subnet[0].id]
      }
    }
  }

  kafka_cluster_client_authentication {
    authentication_type = "NONE" # No client authentication for simplicity in testing
  }

  kafka_cluster_encryption_in_transit {
    encryption_type = "PLAINTEXT" # No encryption for dev testing
  }

  plugin {
    custom_plugin {
      arn      = aws_mskconnect_custom_plugin.example.arn
      revision = aws_mskconnect_custom_plugin.example.latest_revision
    }
  }

  log_delivery {
    worker_log_delivery {
      cloudwatch_logs {
        enabled = true # Minimal logging to CloudWatch for basic inspection
      }
    }
  }
}
