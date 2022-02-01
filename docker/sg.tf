resource "aws_security_group" "nsg_lb" {
  name   = "${var.app}-${terraform.workspace}"
  vpc_id = aws_vpc.Main.id
}

resource "aws_security_group" "nsg_task" {
  name   = "${var.app}-${terraform.workspace}-task"
  vpc_id = aws_vpc.Main.id
}

resource "aws_security_group_rule" "nsg_lb_egress_rule" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nsg_task.id

  security_group_id = aws_security_group.nsg_lb.id
}

resource "aws_security_group_rule" "nsg_task_ingress_rule" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nsg_lb.id

  security_group_id = aws_security_group.nsg_task.id
}

resource "aws_security_group_rule" "nsg_task_egress_rule" {
  type        = "egress"
  from_port   = "0"
  to_port     = "0"
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.nsg_task.id
}