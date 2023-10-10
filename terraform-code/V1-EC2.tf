provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "demo-server" {
    ami = "ami-0bb4c991fa89d4b9b"
    instance_type = "t2.micro"
    key_name = "devkey"
  
}