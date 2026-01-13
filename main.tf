

# =====================
# VPC
# =====================
resource "aws_vpc" "rahul_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "rahul-vpc"
  }
}

# =====================
# Internet Gateway
# =====================
resource "aws_internet_gateway" "rahul_igw" {
  vpc_id = aws_vpc.rahul_vpc.id

  tags = {
    Name = "rahul-igw"
  }
}

# =====================
# Public Subnet
# =====================
resource "aws_subnet" "rahul_public_subnet" {
  vpc_id                  = aws_vpc.rahul_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "rahul-public-subnet"
  }
}

# =====================
# Route Table
# =====================
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

resource "aws_route_table_association" "rahul_public_assoc" {
  subnet_id      = aws_subnet.rahul_public_subnet.id
  route_table_id = aws_route_table.rahul_public_rt.id
}

# =====================
# Security Group
# =====================
resource "aws_security_group" "rahul_web_sg" {
  name   = "rahul-web-sg"
  vpc_id = aws_vpc.rahul_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
    Name = "rahul-sg"
  }
}

# =====================
# EC2 (Amazon Linux + HEAVY PORTFOLIO)
# =====================
resource "aws_instance" "rahul_ec2" {
  ami                    = "ami-0a4408457f9a03be3" # Amazon Linux 2
  instance_type          = "t2.micro"
  key_name               = "mykey"
  subnet_id              = aws_subnet.rahul_public_subnet.id
  vpc_security_group_ids = [aws_security_group.rahul_web_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y nginx
    systemctl start nginx
    systemctl enable nginx

    cat <<'HTML' > /usr/share/nginx/html/index.html
    <!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Rahul Bonkur | Web Developer & DevOps Engineer</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<style>
:root{
  --glow1: rgba(0,180,255,.45);
  --glow2: rgba(0,255,200,.35);
  --bg:#050b12;
  --text:#ffffff;
  --muted:rgba(255,255,255,.65);
}
*{box-sizing:border-box}
body{
  margin:0;
  font-family:'Figtree',system-ui,Arial;
  background:var(--bg);
  color:var(--text);
  overflow-x:hidden;
}

/* BACKGROUND */
canvas{position:fixed;inset:0;z-index:-2}
.glow{position:fixed;width:700px;height:700px;background:var(--glow1);filter:blur(160px);top:10%;left:60%;z-index:-1;animation:float 18s infinite}
.glow.small{width:500px;height:500px;background:var(--glow2);top:55%;left:20%;animation-duration:14s}
@keyframes float{50%{transform:translate(60px,-40px)}}

/* GLOBAL */
.section{padding:140px 8%;max-width:1400px;margin:auto}
.reveal{opacity:0;transform:translateY(60px);transition:1s ease}
.reveal.visible{opacity:1;transform:none}

/* HERO */
.hero{min-height:100vh;display:flex;gap:80px;align-items:center}
.hero h1{font-size:70px;background:linear-gradient(90deg,#5ce1ff,#00ffc3);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.hero p{color:var(--muted);line-height:1.9;max-width:650px}
.hero img{width:480px;border-radius:26px;box-shadow:0 0 120px var(--glow1);transition:.4s}
.hero img:hover{transform:scale(1.05)}

/* CARDS */
.cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:32px}
.card{
  background:rgba(255,255,255,.04);
  border:1px solid rgba(255,255,255,.08);
  border-radius:22px;
  padding:32px;
  backdrop-filter:blur(14px);
  transition:.4s;
}
.card:hover{transform:translateY(-8px);box-shadow:0 0 40px var(--glow2)}
.card img{width:100%;border-radius:14px;margin-bottom:16px;transition:.4s}
.card:hover img{transform:scale(1.07)}

/* SKILLS */
.skills{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:28px}
.skill{padding:22px;border-radius:18px;background:rgba(255,255,255,.03);border:1px solid rgba(255,255,255,.06)}

/* FOOTER */
footer{padding:80px 8%;text-align:center;color:var(--muted)}

@media(max-width:900px){
  .hero{flex-direction:column;text-align:center}
  .hero img{width:300px}
}
</style>
</head>

<body>

<canvas id="dots"></canvas>
<div class="glow"></div>
<div class="glow small"></div>

<!-- HERO -->
<section class="section hero reveal">
  <div>
    <h1>Rahul Bonkur</h1>
    <p>
      Web Developer with a strong foundation in Information Technology and a
      growing specialization in Cloud & DevOps Engineering.
    </p>
    <p>
      I design and build websites — then take full ownership of how they are
      deployed, automated, secured, and scaled in real production environments.
    </p>
    <p>
      Currently transitioning into DevOps, focusing on AWS infrastructure,
      Infrastructure as Code, CI/CD pipelines, and Linux-based systems.
    </p>
  </div>
  <img src="/assets/rahul.jpeg" alt="Rahul Bonkur">
</section>

<!-- DEVOPS / CLOUD -->
<section class="section reveal">
<h2>Cloud & DevOps Focus</h2>
<div class="cards">

<div class="card">
<h3>AWS Core Services</h3>
<p>EC2, VPC, Subnets, Route Tables, Internet Gateway, Security Groups, IAM & S3 remote state.</p>
</div>

<div class="card">
<h3>Networking & Security</h3>
<p>Public/private networking, inbound–outbound rules, SSH access, port exposure and isolation.</p>
</div>

<div class="card">
<h3>Infrastructure as Code</h3>
<p>Terraform modules, variables, outputs, backend configuration and state locking.</p>
</div>

<div class="card">
<h3>CI/CD Pipelines</h3>
<p>Jenkins pipelines for infrastructure provisioning and application deployment automation.</p>
</div>

<div class="card">
<h3>Containers & Docker</h3>
<p>Dockerizing applications, container lifecycle, images, volumes and runtime configs.</p>
</div>

<div class="card">
<h3>Linux Administration</h3>
<p>System services, permissions, Nginx, logs, SSH hardening and server troubleshooting.</p>
</div>

</div>
</section>

<!-- SKILLS -->
<section class="section reveal">
<h2>Technical Skills</h2>
<div class="skills">

<div class="skill">AWS (EC2, VPC, IAM, S3)</div>
<div class="skill">Terraform</div>
<div class="skill">Jenkins</div>
<div class="skill">Docker</div>
<div class="skill">Linux</div>
<div class="skill">Nginx</div>
<div class="skill">Git & GitHub</div>
<div class="skill">CI/CD Pipelines</div>
<div class="skill">WordPress Development</div>
<div class="skill">SEO & Performance</div>

</div>
</section>

<!-- PROJECTS -->
<section class="section reveal">
<h2>Selected Projects</h2>
<div class="cards">

<div class="card"><img src="https://www.hiya.website/wp-content/uploads/2025/11/International-Collagen-Resource.jpg.webp"><h3>International Collagen Resource</h3><p>B2B collagen casing platform built for global manufacturing markets.</p></div>

<div class="card"><img src="https://www.hiya.website/wp-content/uploads/2025/11/Attri-Tech.jpg.webp"><h3>Attri Tech Machines</h3><p>Industrial CNC machinery website with technical clarity.</p></div>

<div class="card"><img src="https://www.hiya.website/wp-content/uploads/2025/06/Ploutos-General-Trading-FZCO.png.webp"><h3>Ploutos General Trading</h3><p>Corporate trading website for global operations.</p></div>

<div class="card"><img src="https://www.hiya.website/wp-content/uploads/2024/12/XLNC-REALTY.png.webp"><h3>XLNC Realty</h3><p>Premium real estate showcase website.</p></div>

<div class="card"><img src="https://www.hiya.website/wp-content/uploads/2025/06/akhanda.png.webp"><h3>Akhanda</h3><p>Culture-driven brand website with immersive visuals.</p></div>

<div class="card"><img src="https://www.hiya.website/wp-content/uploads/2025/06/Madhav-Consultants-Private-Limited-.png.webp"><h3>Madhav Consultants</h3><p>Corporate consulting and professional services website.</p></div>

<div class="card"><img src="https://www.hiya.website/wp-content/uploads/2025/11/Eigen-Prostate-Care-Centre-.jpg.webp"><h3>Eigen Prostate Care</h3><p>Medical website designed for trust and accessibility.</p></div>

<div class="card"><img src="https://www.hiya.website/wp-content/uploads/2024/11/Hoam.Club-removebg-preview.png.webp"><h3>House of Amit Mehta</h3><p>Luxury personal brand and lifestyle website.</p></div>

</div>
</section>

<footer>
© Rahul Bonkur — Web · Cloud · DevOps · Automation
</footer>

<script>
const c=document.getElementById("dots"),ctx=c.getContext("2d");
function resize(){c.width=innerWidth;c.height=innerHeight}
resize();addEventListener("resize",resize);
const dots=[...Array(150)].map(()=>({x:Math.random()*c.width,y:Math.random()*c.height,r:Math.random()*1.4+.3,vx:(Math.random()-.5)*.3,vy:(Math.random()-.5)*.3}));
(function loop(){
ctx.clearRect(0,0,c.width,c.height);
dots.forEach(d=>{
ctx.beginPath();ctx.arc(d.x,d.y,d.r,0,Math.PI*2);
ctx.fillStyle="rgba(255,255,255,.6)";ctx.fill();
d.x+=d.vx;d.y+=d.vy;
if(d.x<0||d.x>c.width)d.vx*=-1;
if(d.y<0||d.y>c.height)d.vy*=-1;
});
requestAnimationFrame(loop);
})();
const obs=new IntersectionObserver(e=>e.forEach(i=>i.isIntersecting&&i.target.classList.add("visible")),{threshold:.15});
document.querySelectorAll(".reveal").forEach(el=>obs.observe(el));
</script>

</body>
</html>
    HTML
  EOF

  tags = {
    Name = "rahul-ec2"
  }
}
