resource "aws_s3_bucket" "ramanuj-dev" {
  bucket = "ramanuj-dev-debezium-bucket" # Replace with a unique bucket name
}

resource "aws_s3_object" "ramanuj-dev" {
  bucket = aws_s3_bucket.ramanuj-dev.id
  key    = "debezium.zip"
  source = "debezium-connector-postgres.zip" # Path to your local Debezium plugin zip file
}
