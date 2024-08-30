data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = "/ramanuj-db-secret" # Reference to the secret name where credentials are stored
}
