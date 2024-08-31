resource "aws_msk_cluster" "ramanuj-dev" {
  cluster_name           = "ramanuj-dev-cluster"
  kafka_version          = "3.6.0"
  number_of_broker_nodes = 2 # Two nodes for high availability

  broker_node_group_info {
    instance_type = "kafka.t3.small" # Cheapest instance type for testing

    client_subnets  = [aws_subnet.msk_subnet[0].id, aws_subnet.msk_subnet[1].id] # Use two subnets
    security_groups = [aws_security_group.msk_security_group.id]

    storage_info {
      ebs_storage_info {
        volume_size = 100 # Minimal storage for testing
      }
    }

    connectivity_info {
      public_access {
        type = "DISABLED" # This enables public access to the brokers
      }
    }
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "PLAINTEXT"
      in_cluster    = false
    }
  }
}
