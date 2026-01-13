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
      margin-bottom: 10px;
    }
    h2 {
      color: #38bdf8;
      margin-top: 40px;
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
      <p>Building responsive websites and automating cloud infrastructure.</p>
    </div>

    <div class="card">
      <h2>Contact</h2>
      <p>GitHub: github.com/rahulbonkur</p>
      <p>LinkedIn: linkedin.com/in/rahulbonkur</p>
    </div>
  </div>
</body>
</html>
HTML
EOF
