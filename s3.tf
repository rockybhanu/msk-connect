resource "aws_s3_bucket" "example" {
  bucket = "example-debezium-bucket" # Replace with a unique bucket name
}

resource "aws_s3_object" "example" {
  bucket = aws_s3_bucket.example.id
  key    = "debezium.zip"
  source = "debezium-connector-postgres.zip" # Path to your local Debezium plugin zip file
}
