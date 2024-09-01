output "msk_cluster_arn" {
  description = "Amazon Resource Name (ARN) of the MSK cluster."
  value       = aws_msk_cluster.ramanuj-dev.arn
}

output "msk_cluster_bootstrap_brokers" {
  description = "Comma separated list of one or more hostname:port pairs of kafka brokers suitable to bootstrap connectivity to the kafka cluster."
  value       = aws_msk_cluster.ramanuj-dev.bootstrap_brokers
}

output "msk_cluster_bootstrap_brokers_public_sasl_iam" {
  description = "One or more DNS names (or IP addresses) and SASL IAM port pairs for public access."
  value       = aws_msk_cluster.ramanuj-dev.bootstrap_brokers_public_sasl_iam
}

output "msk_cluster_bootstrap_brokers_public_sasl_scram" {
  description = "One or more DNS names (or IP addresses) and SASL SCRAM port pairs for public access."
  value       = aws_msk_cluster.ramanuj-dev.bootstrap_brokers_public_sasl_scram
}

output "msk_cluster_bootstrap_brokers_public_tls" {
  description = "One or more DNS names (or IP addresses) and TLS port pairs for public access."
  value       = aws_msk_cluster.ramanuj-dev.bootstrap_brokers_public_tls
}

output "msk_cluster_bootstrap_brokers_sasl_iam" {
  description = "One or more DNS names (or IP addresses) and SASL IAM port pairs."
  value       = aws_msk_cluster.ramanuj-dev.bootstrap_brokers_sasl_iam
}

output "msk_cluster_bootstrap_brokers_sasl_scram" {
  description = "One or more DNS names (or IP addresses) and SASL SCRAM port pairs."
  value       = aws_msk_cluster.ramanuj-dev.bootstrap_brokers_sasl_scram
}

output "msk_cluster_bootstrap_brokers_tls" {
  description = "One or more DNS names (or IP addresses) and TLS port pairs."
  value       = aws_msk_cluster.ramanuj-dev.bootstrap_brokers_tls
}

output "msk_cluster_current_version" {
  description = "Current version of the MSK Cluster used for updates."
  value       = aws_msk_cluster.ramanuj-dev.current_version
}

output "msk_cluster_encryption_at_rest_kms_key_arn" {
  description = "The ARN of the KMS key used for encryption at rest of the broker data volumes."
  value       = aws_msk_cluster.ramanuj-dev.encryption_info[0].encryption_at_rest_kms_key_arn
}

output "msk_cluster_tags_all" {
  description = "A map of tags assigned to the MSK cluster, including those inherited from the provider default_tags configuration block."
  value       = aws_msk_cluster.ramanuj-dev.tags_all
}

output "msk_cluster_zookeeper_connect_string" {
  description = "Comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster."
  value       = aws_msk_cluster.ramanuj-dev.zookeeper_connect_string
}

output "msk_cluster_zookeeper_connect_string_tls" {
  description = "Comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster via TLS."
  value       = aws_msk_cluster.ramanuj-dev.zookeeper_connect_string_tls
}
