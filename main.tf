
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
              <html>
              <head>
                <title>Rahul Bonkur | Portfolio</title>
                <style>
                  body {
                    margin: 0;
                    font-family: Arial, sans-serif;
                    background: #0f172a;
                    color: white;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    height: 100vh;
                  }
                  .card {
                    background: #020617;
                    padding: 40px;
                    border-radius: 12px;
                    box-shadow: 0 0 30px rgba(56,189,248,0.3);
                    text-align: center;
                  }
                  h1 {
                    color: #38bdf8;
                  }
                </style>
              </head>
              <body>
                <div class="card">
                  <h1>Rahul Bonkur</h1>
                  <p>Web Developer → AWS & DevOps</p>
                  <p>Deployed via Jenkins + Terraform</p>
                </div>
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
