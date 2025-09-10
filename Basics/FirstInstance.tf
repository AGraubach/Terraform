terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    access_key = "Access_key"
    secret_key = "Secret_key"
    region = "us-east-2"  
}

resource "aws_instance" "myFirstInstance" {
    ami = "Enter AMI ID"
    instance_type = "Enter instance type" # Ex.: t2.micro
}