######################################
# Public Elastic Load Balancer
######################################
resource "aws_lb" "public-elb" {
  name               = "${var.deploy_name}-public-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public-sg.id]
  subnets            = [aws_subnet.public-subnet-a.id,aws_subnet.public-subnet-b.id]
}

# Public Elastic Load Balancer Target Group
resource "aws_lb_target_group" "public-elb-tg" {
  name     = "${var.deploy_name}-public-elb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  target_type = "ip"
#  health_check {
#    healthy_threshold   = "3"
#    interval            = "30"
#    protocol            = "HTTP"
#    matcher             = "200"
#    timeout             = "3"
#    path                = var.health_check_path
#    unhealthy_threshold = "2"
#  }
}

# Public Elastic Load Balancer Listner
resource "aws_lb_listener" "public-elb-listner" {
  load_balancer_arn = aws_lb.public-elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public-elb-tg.arn
  }
}

######################################
# Private Elastic Load Balancer
######################################
resource "aws_lb" "private-elb" {
  name               = "${var.deploy_name}-private-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.private-sg.id]
  subnets            = [aws_subnet.private-subnet-a.id,aws_subnet.private-subnet-b.id]
}

# Private Elastic Load Balancer Target Group
resource "aws_lb_target_group" "private-elb-tg" {
  name     = "${var.deploy_name}-private-elb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  target_type = "ip"
#  health_check {
#    healthy_threshold   = "3"
#    interval            = "30"
#    protocol            = "HTTP"
#    matcher             = "200"
#    timeout             = "3"
#    path                = var.health_check_path
#    unhealthy_threshold = "2"
#  }  
}

# Private Elastic Load Balancer Listner
resource "aws_lb_listener" "private-elb-listner" {
  load_balancer_arn = aws_lb.private-elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private-elb-tg.arn
  }
}