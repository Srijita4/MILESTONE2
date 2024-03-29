# Create a VPC with CIDR block and appropriate tags

resource "aws_vpc" "main" {
cidr_block = "10.0.0.0/16"

tags = {
Name = "My VPC"
}
    enable_dns_hostnames = true
    enable_dns_support = true
}
# Create a public subnet with CIDR block, availability zone, and tags

resource "aws_subnet" "database_subnet_1" {
vpc_id            = aws_vpc.main.id
cidr_block        = "10.0.1.0/24"
availability_zone = "us-east-1a" # Replace with your desired AZ

tags = {
Name = "Public Subnet"
}
}
resource "aws_subnet" "database_subnet_2" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "10.0.4.0/24"
    availability_zone = "us-east-1b"
    tags = {
      Name = "Database-2b"
    }
  }

# Create an internet gateway and add appropriate tags

resource "aws_internet_gateway" "gw" {
vpc_id = aws_vpc.main.id

tags = {
Name = "Internet Gateway"
}
}

# Create a route table with a route to the internet gateway and tags

resource "aws_route_table" "public_route_table" {
vpc_id = aws_vpc.main.id

route {
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.gw.id
}

tags = {
Name = "Public Route Table"
}
}

# Associate the public route table with the public subnet

resource "aws_route_table_association" "public_subnet_route_table_assoc" {
subnet_id         = aws_subnet.database_subnet_1.id
route_table_id    = aws_route_table.public_route_table.id
}

# Create a security group with SSH access rules and tags

resource "aws_security_group" "ssh" {
name = "SSH"
vpc_id = aws_vpc.main.id

ingress {
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"] # Restrict this for production environments
}

egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}

tags = {
Name = "SSH Security Group"
}
}
#EC2
resource "aws_instance" "webserver" {
ami           = "ami-0b0ea68c435eb488d" # Replace with your desired AMI
instance_type = "t2.micro" # Replace with your desired instance type
vpc_security_group_ids = [aws_security_group.ssh.id]
subnet_id = aws_subnet.database_subnet_1.id
associate_public_ip_address = true     # Assign public IP to the instance
key_name="Terraform-kp"
tags = {
Name = "Web Server"
}
}

#RDS
resource "aws_security_group" "db" {
    name   = "db"
    vpc_id = aws_vpc.main.id
    ingress {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress{
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "DB SG"
    }
  }
  resource "aws_db_instance" "RDS" {
    identifier = "mydb"
    allocated_storage    = 20
    storage_type = "gp2"
    engine               = "mysql"
    engine_version       = "5.7"
    instance_class       = "db.t3.micro"
    multi_az             = false
    username             = "admin123456789"
    password             = "password123"
    skip_final_snapshot  = true
    db_subnet_group_name = aws_db_subnet_group.rds_group.name
    port = 3306
    publicly_accessible = true
    vpc_security_group_ids = [aws_security_group.db.id]
    tags = {
      Name = "RDS database"
    }
  }
  resource "aws_db_subnet_group" "rds_group" {
    name       = "subnet group"
    subnet_ids = [aws_subnet.database_subnet_1.id, aws_subnet.database_subnet_2.id]
    tags = {
      Name = "RDS subnet group"
    }
}
