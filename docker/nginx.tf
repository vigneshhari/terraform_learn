

resource "aws_cloudwatch_log_group" "web" {
  name = "${var.app}-${terraform.workspace}-web"
}

resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster" # Naming the cluster
}

resource "aws_ecs_task_definition" "web" {
  family                   = "${var.app}-web-${terraform.workspace}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.taskRole.arn
  container_definitions    = <<TASK_DEFINITION
    [
      {
        "name": "web",
        "image": "${var.image_uri}",
        "cpu": 256,
        "memory": 512,
        "essential": true,
        "portMappings": [
          {
            "protocol": "tcp",
            "containerPort": 80,
            "hostPort": 80
          }
        ]
      }
    ]
    TASK_DEFINITION
}

resource "aws_ecs_service" "web" {
  name            = "${var.app}-web-${terraform.workspace}"
  cluster         = "${aws_ecs_cluster.my_cluster.id}"             # Referencing our created Cluster
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.web.arn
  desired_count   = 1

  network_configuration {
    security_groups = [aws_security_group.nsg_task.id]
    subnets         = [aws_subnet.privatesubnet_1.id , aws_subnet.privatesubnet_2.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.id
    container_name   = "web"
    container_port   = 80
  }

  # workaround for https://github.com/hashicorp/terraform/issues/12634
  depends_on = [aws_lb_listener.https]
}