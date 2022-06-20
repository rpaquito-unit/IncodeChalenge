output "public_subnet_id_a" {
  description = "The Public Subnet A ID"
  value = "${aws_subnet.public-subnet-a.id}"
}

output "public_subnet_id_b" {
  description = "The Public Subnet B ID"
  value = "${aws_subnet.public-subnet-b.id}"
}

output "private_subnet_id_a" {
  description = "The Private Subnet A ID"
  value = "${aws_subnet.private-subnet-a.id}"
}

output "private_subnet_id_b" {
  description = "The Private Subnet B ID"
  value = "${aws_subnet.private-subnet-b.id}"
}

output "public_sg_id" {
  description = "The Public Security Group ID"
  value = "${aws_security_group.public-sg.id}"
}

output "private_sg_id" {
  description = "The Private Security Group ID"
  value = "${aws_security_group.private-sg.id}"
}

output "public_lb_tg_id" {
  description = "The Public Elastic Load Balancer Target Group ARN"
  value = "${aws_lb_target_group.public-elb-tg.arn}"
}

output "private_lb_tg_id" {
  description = "The Private Elastic Load Balancer Target Group ARN"
  value = "${aws_lb_target_group.private-elb-tg.arn}"
}

output "public_lb_dns" {
  description = "The Public Elastic Load Balancer DNS"
  value = "${aws_lb.public-elb.dns_name}"
}

output "private_lb_dns" {
  description = "The Private Elastic Load Balancer DNS"
  value = "${aws_lb.private-elb.dns_name}"
}