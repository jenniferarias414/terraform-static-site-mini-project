output "bucket_name" {
  description = "Name of the S3 bucket created for the website"
  value       = aws_s3_bucket.website.bucket
}

output "website_endpoint" {
  description = "S3 static website endpoint"
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}

output "website_url" {
  description = "Website URL using HTTP"
  value       = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
}
