# outputs.tf

# Output the VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.msk_vpc.id
}

# Output the Subnet IDs
output "subnet_ids" {
  description = "The IDs of the subnets"
  value       = aws_subnet.msk_subnet[*].id
}

# Output the Security Group ID
output "msk_security_group_id" {
  description = "The ID of the security group for MSK"
  value       = aws_security_group.msk_security_group.id
}

# Output the MSK Cluster ARN
output "msk_cluster_arn" {
  description = "The ARN of the MSK cluster"
  value       = aws_msk_cluster.example.arn
}

# Output the MSK Cluster Name
output "msk_cluster_name" {
  description = "The name of the MSK cluster"
  value       = aws_msk_cluster.example.cluster_name
}

# Output the MSK Cluster Bootstrap Brokers for plaintext and TLS
output "msk_cluster_bootstrap_brokers" {
  description = "The bootstrap brokers for connecting to the MSK cluster"
  value       = aws_msk_cluster.example.bootstrap_brokers
}

output "msk_cluster_bootstrap_brokers_tls" {
  description = "The bootstrap brokers with TLS for connecting to the MSK cluster"
  value       = aws_msk_cluster.example.bootstrap_brokers_tls
}

# Output the MSK Connect Custom Plugin ARN
output "mskconnect_custom_plugin_arn" {
  description = "The ARN of the MSK Connect custom plugin"
  value       = aws_mskconnect_custom_plugin.example.arn
}

# Output the MSK Connect Custom Plugin Revision
output "mskconnect_custom_plugin_revision" {
  description = "The latest revision number of the MSK Connect custom plugin"
  value       = aws_mskconnect_custom_plugin.example.latest_revision
}

# Output the MSK Connect Connector ARN
output "mskconnect_connector_arn" {
  description = "The ARN of the MSK Connect connector"
  value       = aws_mskconnect_connector.debezium_postgres_connector.arn
}

# Output the MSK Connect Connector Name
output "mskconnect_connector_name" {
  description = "The name of the MSK Connect connector"
  value       = aws_mskconnect_connector.debezium_postgres_connector.name
}

# Output the MSK Connect Service Execution Role ARN
output "mskconnect_service_execution_role_arn" {
  description = "The ARN of the service execution role for MSK Connect"
  value       = aws_mskconnect_connector.debezium_postgres_connector.service_execution_role_arn
}

# Output the S3 Bucket Name
output "s3_bucket_name" {
  description = "The name of the S3 bucket for storing the Debezium plugin"
  value       = aws_s3_bucket.example.bucket
}

# Output the S3 Object Key
output "s3_object_key" {
  description = "The key of the S3 object for the Debezium plugin"
  value       = aws_s3_object.example.key
}

# Output the MSK Connect Capacity (autoscaling settings)
output "mskconnect_connector_autoscaling_settings" {
  description = "Autoscaling settings of the MSK Connect connector"
  value = {
    min_worker_count = aws_mskconnect_connector.debezium_postgres_connector.capacity[0].autoscaling[0].min_worker_count
    max_worker_count = aws_mskconnect_connector.debezium_postgres_connector.capacity[0].autoscaling[0].max_worker_count
    mcu_count        = aws_mskconnect_connector.debezium_postgres_connector.capacity[0].autoscaling[0].mcu_count
  }
}

# Corrected Output for MSK Connect Logging Configuration
output "mskconnect_logging_configuration" {
  description = "Logging configuration for MSK Connect"
  value       = aws_mskconnect_connector.debezium_postgres_connector.log_delivery[0].worker_log_delivery[0].cloudwatch_logs[0].enabled
}
