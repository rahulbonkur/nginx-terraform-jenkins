output "website_url" {
  value = "http://${aws_instance.portfolio.public_ip}"
}
