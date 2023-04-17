data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}


data "aws_vpc" "default" {
  default = true
}


resource "aws_instance" "blog" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type

  tags = {
    Name = "Learning Terraform"
  }
}

resource "aws_security_group" "blog" {
  name        = "blog-sg"
  description = "Allow HTTP and HTTPs in, allow everything out"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "blog_http_in" {
  type        = "ingress"
  from_port   = 80
  in_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.blog.id
}

resource "aws_security_group_rule" "blog_https_in" {
  type        = "ingress"
  from_port   = 443
  in_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.blog.id
}

resource "aws_security_group_rule" "everything_out" {
  type        = "egress"
  from_port   = 0
  in_port     = 0             # all ports
  protocol    = "-1"          # all protocols
  cidr_blocks = ["0.0.0.0/0"] # all ip ranges

  security_group_id = aws_security_group.blog.id
}



