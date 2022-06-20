resource "aws_ecs_cluster" "fe-main-cluster" {
  name = "${var.deploy_name}-fe-cluster"
}

resource "aws_ecs_task_definition" "fe-main-taskdefinition" {
  family                   = "${var.deploy_name}-fe-task-family"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([
    {
      name      = "${var.deploy_name}-fe-container"
      image     = "887766911020.dkr.ecr.us-east-1.amazonaws.com/webapp:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      environment = [
        {
          name = "backendDns"
          value = var.private_lb_dns
        }
      ]
    }
  ])
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.deploy_name}-ecsTaskExecutionRole"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.deploy_name}-ecsTaskRole"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "ecs_task_role_policy" {
  name        = "${var.deploy_name}-ecsTaskRole-policy"
  description = "Policy that allows access to AWS things"

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Allow",
           "Action": [
               "dynamodb:*"
           ],
           "Resource": "*"
       }
   ]
}
EOF
}
 
resource "aws_iam_role_policy_attachment" "ecs-task-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_task_role_policy.arn
}

resource "aws_ecs_service" "fe-main-service" {
  name                               = "${var.deploy_name}-FE-service"
  cluster                            = aws_ecs_cluster.fe-main-cluster.id
  task_definition                    = aws_ecs_task_definition.fe-main-taskdefinition.id
  desired_count                      = 2
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [var.public_sg_id]
    subnets          = [var.public_subnet_id_a, var.public_subnet_id_b]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.public_lb_tg_id
    container_name   = "${var.deploy_name}-fe-container"
    container_port   = "80"
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}