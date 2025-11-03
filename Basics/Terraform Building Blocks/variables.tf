variable "AWS_SECRET_KEY" {}
variable "AWS_ACCESS_KEY" {}
variable "AWS_REGION" {
    default = "us-east-2"
}
variable "Security_Group" {
    default = "sg-0297e2fe94817ab92"
}
variable "AMIS" {
    type = map
    default = {
        us-east-1 = "ami-0e8459476fed2e23b"
        us-east-2 = "ami-07f06ca5176c81f6c"
        us-west-1 = "ami-0b5fb2ffd31f97947"
        us-west-2 = "ami-083654bd07b5da81d"
    }
}

variable "PATH_TO_PRIVATE_KEY" {
    default = "levelup_key"
}
variable "PATH_TO_PUBLIC_KEY" {
    default = "levelup_key.pub"
}
variable "INSTANCE_USERNAME" {
    default = "ubuntu"
}