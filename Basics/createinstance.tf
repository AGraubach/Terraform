terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "6.12.0"
        }
    }
}
provider "aws" {
    region = "us-east-2"
    access_key = "Enter Here"
    secret_key = "Enter Here"
}

resource "aws_instance" "MyFirstInstance" {
    ami = "ami-0d9a665f802ae6227"
    instance_type = "t2.micro"
}
