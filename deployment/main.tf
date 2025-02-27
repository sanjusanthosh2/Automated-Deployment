provider "aws" {
  region = "eu-north-1" # Change this to your AWS region
}

resource "aws_s3_bucket" "fitness_store" {
  bucket = "fitness-equipment-store-12345"
}

resource "aws_s3_bucket_website_configuration" "fitness_store" {
  bucket = aws_s3_bucket.fitness_store.id

  index_document {
    suffix = "store.html"
  }

  error_document {
    key = "store.html"
  }
}

resource "aws_s3_bucket_policy" "public_access" {
  bucket = aws_s3_bucket.fitness_store.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::fitness-equipment-store-12345/*"
      }
    ]
  })
}

resource "aws_s3_object" "website_file" {
  bucket       = aws_s3_bucket.fitness_store.id
  key          = "store.html"
  source       = "store.html"
  content_type = "text/html"
}

output "website_url" {
  value = "http://${aws_s3_bucket.fitness_store.bucket}.s3-website-${var.region}.amazonaws.com"
}
