resource "aws_instance" "CreateInstance" {
    ami = lookup(var.AMIS, var.AWS_REGION)
    instance_type = "t2.micro"

    tags = {
        Name = "Demo-Instance"
    }
    security_groups = "${var.Security_Group}"
}