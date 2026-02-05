# Application Load Balancer
resource "aws_lb" "alb" {
  name               = "${var.env}-strapi-alb"
  load_balancer_type = "application"
  internal           = false

  subnets = [
    aws_subnet.public.id,
    aws_subnet.public_2.id
  ]

  security_groups = [aws_security_group.alb_sg.id]

  tags = {
    Name = "${var.env}-alb"
  }
}

# Target Group for Strapi
resource "aws_lb_target_group" "strapi_tg" {
  name     = "${var.env}-strapi-tg"
  port     = var.strapi_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id

  health_check {
    path                = "/admin"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }

  tags = {
    Name = "${var.env}-strapi-tg"
  }
}

# Attach EC2 to Target Group
resource "aws_lb_target_group_attachment" "strapi_attach" {
  target_group_arn = aws_lb_target_group.strapi_tg.arn
  target_id        = aws_instance.strapi.id
  port             = var.strapi_port
}

# Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.strapi_tg.arn
  }
}
