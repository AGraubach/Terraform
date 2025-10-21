variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
    default = "us-east-2"
}
variable "Security_Group" {
    type = list
    default = ["sg-24076", "sg-90890", "sg-23456789"]
}

variable "AMIS" {
    type = map
    default = {
        us-east-1 = "ami-0e8459476fed2e23b"
        us-east-2 = "ami-07f06ca5176c81f6c"
        us-west-1 = "ami-0b5fb2ffd31f97947"
    }
}