resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb_sg"
  description = "Allow HTTP/HTTPS traffic from internet to alb"
  vpc_id      = var.vpc_id

  ingress{
    description = "Allow traffic for HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

 ingress {
    description = "Allow traffic for HTTPS"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "${var.project_name}-alb_sg"
  }
}



resource "aws_security_group" "ecs_sg" {
  name        = "${var.project_name}-ecs_sg"
  description = "Allow traffic from ALB to ECS"
  vpc_id      = var.vpc_id

  ingress{
    description = "Requests from alb only"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
}


  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "${var.project_name}-ecs_sg"
  }
}
