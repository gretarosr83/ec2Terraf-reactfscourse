terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
    profile = "default"
    region = "us-east-1"
    # ec2-user access_key
    # access_key= 
    # secret_key= 
   

}

resource "tls_private_key" "rsa_4096" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.key_name}"
    public_key = tls_private_key.rsa_4096.public_key_openssh
    }

resource "local_file" "private_key" {
    content = tls_private_key.rsa_4096.private_key_pem
    filename = "${var.key_name}"
}

######################################
#creating EC2 instance
######################################
resource "aws_instance" "demo_instance" {
    ami = "${lookup(var.amis,var.region)}"
    instance_type = "t2.micro"
    key_name = aws_key_pair.key_pair.key_name
    # key_name = "demoKeyPair"
    # vpc_security_group_ids = ["sg-0d85898e4dbb0c7d2"]

    tags = {
      Name= "reactapp_fscourse"
    }

provisioner "file" {
      source = "task.sh"
      destination = "/tmp/task.sh"

    }

    provisioner "remote-exec" {
        inline = [ 
            "chmod +x /tmp/task.sh", #permision of the execution to the file
            "sudo /tmp/task.sh" #command to execute the file
         ]
    }

}
# locals {
#     inbound_ports = [80, 22]
#     outbound_ports = [443, 1433]
# }



resource "aws_security_group" "react_sg" {
    name="reactapp_fscourse_sg"
    description = "Allow HTTP and SSH access"

      dynamic "ingress" {
        for_each = var.ingress_ports
        iterator = ports
        content {
            from_port   = ports.value
            to_port     = ports.value
            protocol    = "tcp"
            cidr_blocks = [ "0.0.0.0/0" ]
        }

        
    }

     dynamic "egress" {
        for_each = var.egress_ports
        content {
            from_port   = egress.value
            to_port     = egress.value
            protocol    = "tcp"
            cidr_blocks = [ "0.0.0.0/0" ]
        }

        
    }
  
    # egress{
    #         from_port   = 0
    #         to_port     = 0
    #         protocol    = "-1"
    #         # cidr_blocks = [ var.vpc-cidr ]
    #         cidr_blocks = [ "0.0.0.0/0" ]
     
    # }

      # ingress {
      #   from_port = 22
      #   to_port = 22
      #   protocol = "tcp"
      #   cidr_blocks = [ "0.0.0.0/0" ]
      # }

      # ingress = {
      #   from_port=80
      #   to_port=80
      #   protocol="tcp"
      #   cidr_blocks=["0.0.0.0/0"]
      # }

      # egress{
      #   from_port = 0
      #   to_port = 0
      #   protocol = "-1"
      #   cidr_blocks = [ "0.0.0.0/0" ]
      # }      
    }


