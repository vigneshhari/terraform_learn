resource "aws_lb" "main" {
  name               = "${var.app}-${terraform.workspace}"
  load_balancer_type = "application"
  internal           = false
  subnets            = [aws_subnet.publicsubnets.id, aws_subnet.privatesubnets.id]
  security_groups    = [aws_security_group.nsg_lb.id]
}

resource "aws_lb_target_group" "main" {
  name        = "${var.app}-${terraform.workspace}"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.Main.id
  health_check {
    path = "/health/"
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.main.id
    type             = "forward"
  }
}

resource "aws_security_group_rule" "ingress_lb_https" {
  type              = "ingress"
  description       = "HTTPS"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nsg_lb.id
}