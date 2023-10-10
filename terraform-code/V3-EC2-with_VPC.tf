provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "demo-server" {
    ami = "ami-0bb4c991fa89d4b9b"
    instance_type = "t2.micro"
    key_name = "devkey"
    //security_groups = ["demo-sg"]
    vpc_security_group_ids = [aws_security_group.demo-sg.id]
    subnet_id = aws_subnet.demo-public_subent_01.id 
  
}
resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "SSH Access"
  vpc_id = aws_vpc.demo-vpc.id
 
  ingress {
    description      = "SSH Access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "SSH Port"
  }
}

  resource "aws_vpc" "demo-vpc" {
       cidr_block = "10.1.0.0/16"
       tags = {
        Name = "demo-vpc"
     }
   }
   //Create a Subnet 
resource "aws_subnet" "demo-public_subent_01" {
    vpc_id = aws_vpc.demo-vpc.id
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {
      Name = "demo-public_subent_01"
    }
}
//Create a Subnet 
resource "aws_subnet" "demo-public_subent_02" {
    vpc_id = aws_vpc.demo-vpc.id
    cidr_block = "10.1.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1b"
    tags = {
      Name = "demo-public_subent_02"
    }
}
//Creating an Internet Gateway 
resource "aws_internet_gateway" "demo-igw" {
    vpc_id = aws_vpc.demo-vpc.id
    tags = {
      Name = "demo-igw"
    }
}
// Create a route table 
resource "aws_route_table" "demo-public-rt" {
    vpc_id = aws_vpc.demo-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.demo-igw.id
    }
    tags = {
      Name = "demo-public-rt"
    }
}
// Associate subnet with route table

resource "aws_route_table_association" "demo-rta-public-subent-01" {
    subnet_id = aws_subnet.demo-public_subent_01.id
    route_table_id = aws_route_table.demo-public-rt.id
}
// Associate subnet with route table

resource "aws_route_table_association" "demo-rta-public-subent-02" {
    subnet_id = aws_subnet.demo-public_subent_02.id
    route_table_id = aws_route_table.demo-public-rt.id
}