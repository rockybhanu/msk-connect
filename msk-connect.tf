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
    "connector.class"                = "io.debezium.connector.postgresql.PostgresConnector"
    "tasks.max"                      = "1"
    "database.hostname"              = "postgres.ramanuj.dev"
    "database.port"                  = "30032"
    "database.user"                  = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)["username"]
    "database.password"              = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)["password"]
    "database.dbname"                = "crm"
    "database.server.name"           = "crm"
    "topic.prefix"                   = "crm_cdc"
    "table.include.list"             = "public.customer_records"
    "include.schema.changes"         = "false"
    "plugin.name"                    = "pgoutput"
    "transforms"                     = "unwrap,insertKey"
    "transforms.unwrap.type"         = "io.debezium.transforms.ExtractNewRecordState"
    "transforms.insertKey.type"      = "org.apache.kafka.connect.transforms.ValueToKey"
    "transforms.insertKey.fields"    = "id"
    "key.converter"                  = "org.apache.kafka.connect.storage.StringConverter"
    "value.converter"                = "org.apache.kafka.connect.json.JsonConverter"
    "value.converter.schemas.enable" = true
    "value.converter.decimal.format" = "numeric"
  }

  kafka_cluster {
    apache_kafka_cluster {
      bootstrap_servers = aws_msk_cluster.ramanuj-dev.bootstrap_brokers_sasl_iam
      vpc {
        security_groups = [aws_security_group.msk_security_group.id]
        subnets         = [aws_subnet.private_subnet[0].id, aws_subnet.private_subnet[1].id] # Private subnets
      }
    }
  }

  kafka_cluster_client_authentication {
    authentication_type = "IAM"
  }

  kafka_cluster_encryption_in_transit {
    encryption_type = "TLS"
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
        enabled   = true
        log_group = aws_cloudwatch_log_group.msk_connect_log_group.name
      }
    }
  }

  timeouts {
    create = "90m"
    update = "90m"
    delete = "90m"
  }
}
