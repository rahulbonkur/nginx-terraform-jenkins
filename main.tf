

################################
# VPC
################################
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "portfolio-vpc"
  }
}

################################
# Public Subnet
################################
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

################################
# Internet Gateway
################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "portfolio-igw"
  }
}

################################
# Route Table
################################
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

################################
# Route Table Association
################################
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

################################
# Security Group
################################
resource "aws_security_group" "web_sg" {
  name   = "web-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
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
    Name = "web-sg"
  }
}

################################
# EC2 Instance (Amazon Linux)
################################
resource "aws_instance" "portfolio_ec2" {
  ami           = "ami-0f5ee92e2d63afc18"   # Amazon Linux 2023 (ap-south-1)
  instance_type = "t2.micro"
  key_name      = "mykey"

  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    set -eux

    yum update -y
    yum install -y nginx

    systemctl start nginx
    systemctl enable nginx

    cat <<HTML > /usr/share/nginx/html/index.html
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <title>Rahul Bonkur | Portfolio</title>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <style>
        body {
          margin: 0;
          font-family: Arial, sans-serif;
          background: #0f172a;
          color: #e5e7eb;
        }
        .container {
          max-width: 1000px;
          margin: auto;
          padding: 60px 20px;
        }
        h1 {
          font-size: 42px;
        }
        h2 {
          color: #38bdf8;
        }
        .card {
          background: #020617;
          padding: 20px;
          border-radius: 12px;
          margin-top: 20px;
        }
      </style>
    </head>
    <body>
      <div class="container">
        <h1>Rahul Bonkur</h1>
        <p>Web Developer | AWS & DevOps Enthusiast</p>

        <div class="card">
          <h2>Skills</h2>
          <p>HTML, CSS, WordPress, AWS, Terraform, Jenkins</p>
        </div>

        <div class="card">
          <h2>Experience</h2>
          <p>Automating cloud infrastructure and CI/CD pipelines.</p>
        </div>

        <div class="card">
          <h2>Contact</h2>
          <p>GitHub: github.com/rahulbonkur</p>
        </div>
      </div>
    </body>
    </html>
    HTML
  EOF

  tags = {
    Name = "portfolio-ec2"
  }
}
