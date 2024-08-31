resource "aws_mskconnect_custom_plugin" "ramanuj_dev" {
  name         = "debezium-ramanuj-dev"
  content_type = "ZIP"

  location {
    s3 {
      bucket_arn = aws_s3_bucket.ramanuj_dev.arn
      file_key   = aws_s3_object.ramanuj_dev.key
    }
  }
}