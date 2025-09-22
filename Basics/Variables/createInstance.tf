resource "aws" "CreateInstance" {
    ami = "ami-001209a78b30e703c"
    instance_type = "t2.micro"

    tags = {
        Name = "Demo-Instance"
    }

}