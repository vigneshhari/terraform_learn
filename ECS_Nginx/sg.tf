resource "aws_security_group" "nsg_lb" {
  name   = "${var.app}-${terraform.workspace}"
  vpc_id = aws_vpc.Main.id
}

resource "aws_security_group" "nsg_task" {
  name   = "${var.app}-${terraform.workspace}-task"
  vpc_id = aws_vpc.Main.id
}

# ECS Task Security Group
# Only allow connections from LB at port 80

resource "aws_security_group_rule" "nsg_task_ingress_rule" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nsg_lb.id

  security_group_id = aws_security_group.nsg_task.id
}

# Allow connections to external resources from ECS

resource "aws_security_group_rule" "nsg_task_egress_rule" {
  type        = "egress"
  from_port   = "0"
  to_port     = "0"
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.nsg_task.id
}

# Load Balancer Security Groups
# Allow 80 and 443 to the internet

resource "aws_security_group_rule" "ingress_lb_https" {
  type              = "ingress"
  description       = "HTTPS"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nsg_lb.id
}

resource "aws_security_group_rule" "ingress_lb_http" {
  type              = "ingress"
  description       = "HTTP"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nsg_lb.id
}

# Allow only connections from the task itself

resource "aws_security_group_rule" "nsg_lb_egress_rule" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nsg_task.id

  security_group_id = aws_security_group.nsg_lb.id
}
