terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "6.12.0"
      }
    }
}
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

provider "aws" {
    region = "us-east-1"
    access_key = var.AWS_ACCESS_KEY
    secret_key = var.AWS_SECRET_KEY
}

resource "aws_instance" "First_instance" {
    ami = "ami-0c398cb65a93047f2"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.instances.name]
    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World 1" > index.html
                python3 -m http.server 8080 &
                EOF
    tags = {
        Name = "First_instance"
    }
}

resource "aws_instance" "Second_instance" {
    ami = "ami-0c398cb65a93047f2"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.instances.name]
    user_data = <<-EOF
                #!/bin/bash
                echo "Hello World 2" > index.html
                python3 -m http.server 8080 &
                EOF
    tags = {
        Name = "Second_instance"
    }
}

resource "aws_s3_bucket" "bucket" {
    bucket = "devops-terraform-project-web-bucket"
    force_destroy = true
}

resource "aws_s3_bucket_versioning" "versioning" {
    bucket = aws_s3_bucket.bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
    bucket = aws_s3_bucket.bucket.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "default_subnet" {}

resource "aws_security_group" "instances" {
    name = "instance-security-group"
}
resource "aws_vpc_security_group_ingress_rule" "allow_http_inbound" {
    security_group_id = aws_security_group.instances.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 8080
    to_port = 8080
    ip_protocol = "tcp"
}

resource "aws_lb_listener" "http_listener" {
    load_balancer_arn = aws_lb.load_balancer.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "fixed-response"

        fixed_response {
            content_type = "text/plain"
            message_body = "404: page not found"
            status_code = "404"
        }
    }
}

resource "aws_lb_target_group" "instances" {
    name = "instances-target-group"
    port = 8080
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id

    health_check {
        path = "/"
        matcher = "200"
        interval = 15
        timeout = 4
        healthy_threshold = 3
        unhealthy_threshold = 3
    }
}

resource "aws_lb_target_group_attachment" "instance_1" {
    target_group_arn = aws_lb_target_group.instances.arn
    target_id = aws_instance.First_instance.id
    port = 8080
}

resource "aws_lb_target_group_attachment" "instance_2" {
    target_group_arn = aws_lb_target_group.instances.arn
    target_id = aws_instance.Second_instance.id
    port = 8080    
}

resource "aws_lb_listener_rule" "forward_to_instances" {
    listener_arn = aws_lb_listener.http_listener.arn
    priority = 100

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.instances.arn
    }

    condition {
        path_pattern {
            values = ["*"]
        }
    }
}
resource "aws_db_instance" "default" {
    allocated_storage = 10
    db_name = "projectdb"
    engine = "mysql"
    engine_version = "8.0"
    instance_class = "db.t3.micro"
    username = "usernamedb"
    password = "passworddb"
}

resource "aws_security_group" "alb_security_group" {
    name = "alb-security-group"
}

resource "aws_vpc_security_group_ingress_rule" "allow_alb_http_inbound" {
    security_group_id = aws_security_group.alb_security_group.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 8080
    to_port = 8080
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_alb_http_outbound" {
    security_group_id = aws_security_group.alb_security_group.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_lb" "load_balancer" {
    name = "web-load-balancer"
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb_security_group.id]
    subnets = data.aws_subnets.default_subnet.ids
}

