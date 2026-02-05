resource "aws_key_pair" "this" {
  key_name   = "strapi-key"
  public_key = file("strapi-key.pub")
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "strapi" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = aws_key_pair.this.key_name

  user_data = file("user_data.sh")

  associate_public_ip_address = false

  tags = {
    Name = "${var.env}-strapi-ec2"
  }
}
