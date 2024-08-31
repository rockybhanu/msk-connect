resource "aws_s3_bucket" "ramanuj_dev" {
  bucket = "ramanuj-dev-debezium-bucket" # Replace with a unique bucket name
}

resource "aws_s3_object" "ramanuj_dev" {
  bucket = aws_s3_bucket.ramanuj_dev.id
  key    = "debezium.zip"
  source = "debezium-connector-postgres.zip" # Path to your local Debezium plugin zip file
}
