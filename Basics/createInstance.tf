resource "aws_instance" "FirstInstance" {
    count = 3
    ami = "Enter AMI ID"
    instance_type = "Enter instance type" # Ex.: t2.micro

    tags = {
        Name = "demo-instance-${count.index}"
    }
}