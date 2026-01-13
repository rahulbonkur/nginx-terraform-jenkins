output "public_ip" {
  value = aws_instance.rahul_ec2.public_ip
}

output "website_url" {
  value = "http://${aws_instance.rahul_ec2.public_ip}"
}
