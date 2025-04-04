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

# 🔐 Upload your public SSH key for EC2 login
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/aws_key.pub")  # Replace path if needed
}

# 🔐 Security group: allows SSH and HTTP traffic
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-allow-http-ssh"
  description = "Allow inbound traffic on port 22 and 80"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # ⚠️ Restrict to your IP in production
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Public web access
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 💻 EC2 instance with Docker and Nginx setup
resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"  # ✅ Amazon Linux 2 AMI for eu-north-1 (Update if outdated)
  instance_type = "t2.micro"              # ✅ Free-tier eligible
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.ec2_sg.name]

  # 🚀 Automatically install Docker and Nginx + serve HTML page
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras enable nginx1 -y
              yum install -y nginx docker
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Hello from EC2!</h1><p>This is store.html hosted on EC2.</p>" > /usr/share/nginx/html/store.html
              cp /usr/share/nginx/html/store.html /usr/share/nginx/html/index.html
              systemctl restart nginx
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ec2-user
              EOF

  tags = {
    Name = "EC2-Docker-Web-Server"
  }
}

# 🌍 Output public IP after apply
output "ec2_public_ip" {
  description = "Public IP of your EC2 instance"
  value       = aws_instance.web_server.public_ip
}
