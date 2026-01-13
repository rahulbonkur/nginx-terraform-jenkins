
# -------------------------
# VPC
# -------------------------
resource "aws_vpc" "rahul_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "rahul-vpc"
  }
}

# -------------------------
# Internet Gateway
# -------------------------
resource "aws_internet_gateway" "rahul_igw" {
  vpc_id = aws_vpc.rahul_vpc.id

  tags = {
    Name = "rahul-igw"
  }
}

# -------------------------
# Public Subnet
# -------------------------
resource "aws_subnet" "rahul_public_subnet" {
  vpc_id                  = aws_vpc.rahul_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "rahul-public-subnet"
  }
}

# -------------------------
# Route Table
# -------------------------
resource "aws_route_table" "rahul_public_rt" {
  vpc_id = aws_vpc.rahul_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rahul_igw.id
  }

  tags = {
    Name = "rahul-public-rt"
  }
}

# -------------------------
# Route Table Association
# -------------------------
resource "aws_route_table_association" "rahul_public_assoc" {
  subnet_id      = aws_subnet.rahul_public_subnet.id
  route_table_id = aws_route_table.rahul_public_rt.id
}

# -------------------------
# Security Group
# -------------------------
resource "aws_security_group" "rahul_web_sg" {
  name        = "rahul-web-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.rahul_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rahul-sg"
  }
}

# -------------------------
# EC2 (Amazon Linux)
# -------------------------
resource "aws_instance" "rahul_ec2" {
  ami                         = "ami-0a4408457f9a03be3" # Amazon Linux 2023
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.rahul_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.rahul_web_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              set -eux

              # Update system
              dnf update -y

              # Install nginx (AMAZON LINUX WAY)
              dnf install -y nginx

              # Start & enable nginx
              systemctl enable nginx
              systemctl start nginx

              # Deploy portfolio
              cat <<HTML > /usr/share/nginx/html/index.html
              <!DOCTYPE html>
              <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <title>Rahul Bonkur | Cloud & DevOps Engineer</title>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <style>
        body {
          margin: 0;
          font-family: 'Segoe UI', sans-serif;
          background: #020617;
          color: #e5e7eb;
        }
        header {
          background: linear-gradient(135deg, #020617, #0f172a);
          padding: 80px 20px;
          text-align: center;
        }
        header h1 {
          font-size: 48px;
          color: #38bdf8;
        }
        header p {
          font-size: 18px;
          opacity: 0.85;
        }
        section {
          max-width: 1100px;
          margin: auto;
          padding: 60px 20px;
        }
        h2 {
          color: #38bdf8;
          margin-bottom: 20px;
        }
        .grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
          gap: 20px;
        }
        .card {
          background: #020617;
          border: 1px solid #1e293b;
          padding: 25px;
          border-radius: 14px;
          box-shadow: 0 0 20px rgba(56,189,248,0.15);
        }
        footer {
          background: #020617;
          text-align: center;
          padding: 30px;
          border-top: 1px solid #1e293b;
          opacity: 0.8;
        }
      </style>
    </head>
    <body>

      <header>
        <h1>Rahul Bonkur</h1>
        <p>Cloud & DevOps Engineer | AWS | Terraform | Jenkins</p>
        <p>Building automated, scalable & production-ready cloud systems</p>
      </header>

      <section>
        <h2>About Me</h2>
        <div class="card">
          <p>
            I am a Cloud & DevOps Engineer with a strong foundation in Web Development and
            Infrastructure Automation. I specialize in designing AWS architectures,
            building CI/CD pipelines, and deploying production-ready systems using
            Terraform and Jenkins.
          </p>
        </div>
      </section>

      <section>
        <h2>Core Skills</h2>
        <div class="grid">
          <div class="card">AWS (EC2, VPC, IAM, S3)</div>
          <div class="card">Terraform (IaC)</div>
          <div class="card">Jenkins (CI/CD)</div>
          <div class="card">Linux (Amazon Linux)</div>
          <div class="card">Docker & Containers</div>
          <div class="card">Networking & Security</div>
        </div>
      </section>

      <section>
        <h2>Projects</h2>
        <div class="grid">
          <div class="card">
            <h3>Automated AWS Infra</h3>
            <p>Provisioned VPC, EC2, Security Groups using Terraform.</p>
          </div>
          <div class="card">
            <h3>CI/CD Pipeline</h3>
            <p>Built Jenkins pipelines for automated build & deployment.</p>
          </div>
          <div class="card">
            <h3>Nginx Web Hosting</h3>
            <p>Automated web hosting using Amazon Linux & Nginx.</p>
          </div>
        </div>
      </section>

      <section>
        <h2>Career Goal</h2>
        <div class="card">
          <p>
            My goal is to become a highly skilled Cloud & DevOps Engineer working on
            large-scale infrastructure, automation, and high-availability systems.
          </p>
        </div>
      </section>

      <footer>
        <p>© Rahul Bonkur | Powered by Terraform & AWS</p>
      </footer>

    </body>
    </html>
              HTML
              EOF

  tags = {
    Name = "rahul-ec2"
  }
}
# -------------------------
# Outputs
# -------------------------
