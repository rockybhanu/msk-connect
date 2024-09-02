resource "aws_msk_cluster" "ramanuj-dev" {
  cluster_name           = "ramanuj-dev-cluster"
  kafka_version          = "3.6.0"
  number_of_broker_nodes = 2 # Two nodes for high availability

  broker_node_group_info {
    instance_type = "kafka.t3.small"

    client_subnets  = [aws_subnet.public_subnet[0].id, aws_subnet.public_subnet[1].id] # Use public subnets for MSK
    security_groups = [aws_security_group.msk_security_group.id]

    storage_info {
      ebs_storage_info {
        volume_size = 100
      }
    }

    connectivity_info {
      public_access {
        type = "SERVICE_PROVIDED_EIPS" # Enables public access to the brokers
        #type = "DISABLED" # Enables public access to the brokers
      }
    }
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
  }

  client_authentication {
    sasl {
      iam   = true
      scram = true
    }
  }

  configuration_info {
    arn      = aws_msk_configuration.custom_config.arn
    revision = aws_msk_configuration.custom_config.latest_revision
  }
}
