# Automated Deployment of Fitness Equipment Store using AWS S3, GitHub Actions, and Docker

## 📌 Project Overview
This project automates the deployment of a **static website (Fitness Equipment Store)** using **AWS S3, GitHub Actions, and Docker**. The entire infrastructure is managed using **Terraform**, and a **CI/CD pipeline** is set up to ensure seamless deployments whenever code is updated in the GitHub repository.

## 🚀 Features Implemented
- **AWS S3 for static website hosting**
- **Terraform for Infrastructure as Code (IaC)**
- **GitHub Actions for CI/CD automation**
- **Docker for containerized deployment on AWS EC2**
- **AWS CloudFront for CDN performance optimization**
- **Amazon Route 53 for domain management**
- **AWS CloudWatch for monitoring and logging**
- **Systemd for Docker container auto-restart on EC2**
- **Git SSH authentication and repository management**

## 🏗️ Architecture Diagram
The architecture follows a structured **CI/CD workflow**, as shown in the diagram below:

![Architecture Diagram](./architecture-diagram.png) *(Ensure to replace with the actual image in your repo)*

## 📂 Project Structure
```bash
.
├── .github/workflows/deploy.yml  # GitHub Actions workflow for CI/CD
├── .terraform/                   # Terraform state files (ignored in Git)
├── Dockerfile                    # Docker container setup for deployment
├── main.tf                        # Terraform configuration for AWS S3
├── variables.tf                   # Terraform variable definitions
├── store.html                     # Static website HTML file
├── terraform.tfstate               # Terraform state file (ignored in Git)
├── README.md                      # Project documentation
```

## 🛠️ Setup Instructions

### **1️⃣ Clone the Repository**
```sh
git clone git@github.com:lavuchandu169/live.git
cd live
```

### **2️⃣ Configure AWS Credentials**
Ensure AWS CLI is configured with your access credentials:
```sh
aws configure
```

### **3️⃣ Deploy Infrastructure using Terraform**
```sh
terraform init
terraform apply -auto-approve
```

### **4️⃣ Enable CI/CD with GitHub Actions**
The **GitHub Actions workflow** (`.github/workflows/deploy.yml`) is automatically triggered when changes are pushed.

To manually trigger a deployment:
```sh
git add .
git commit -m "Update website"
git push origin main
```

### **5️⃣ Deploy Using Docker on AWS EC2**
To run the website in a **Docker container** on AWS EC2:
```sh
docker build -t fitness-store .
docker run -d -p 80:80 fitness-store
```

If deploying to EC2:
```sh
ssh -i your-key.pem ec2-user@your-ec2-ip
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
docker run -d -p 80:80 your-dockerhub-username/fitness-store:latest
```

## 📌 Git SSH Authentication (for Secure Pushes)
```sh
ssh-keygen -t rsa -b 4096 -C "your-email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub  # Copy this to GitHub SSH Keys
```

## 📊 Monitoring with AWS CloudWatch
Monitor logs and deployments with:
```sh
aws logs describe-log-groups
aws logs tail /var/log/nginx/access.log --follow
```

## ❌ Troubleshooting
| Issue | Solution |
|--------|------------|
| **S3 Website Not Accessible** | Ensure public access is enabled and the correct bucket policy is applied |
| **Git Push Rejected (Large Files)** | Remove large files from tracking using `.gitignore` and re-commit |
| **Docker Container Not Running on Restart** | Use `systemd` to enable auto-restart |

## 📝 License
This project is open-source and available for modification.

📌 **Maintained by:** lavuchandu169 🚀
