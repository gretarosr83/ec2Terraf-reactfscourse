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


    # provisioner "remote-exec" {
    #     inline = [ 
    #         "sudo /tmp/sdocker_image.sh" #command to execute the file
    #      ]
    # }

    user_data = <<-EOF
    #!/bin/bash
                    #LINUX ---|
                    #sudo yum update -y
                    #sudo amazon-linux-extras enable nginx1
                    #sudo yum install -y nginx
                    #sudo systemctl start nginx
                    #sudo systemctl enable nginx


                    #UBUNTU Server
                    sudo apt-get update -y
                    sudo apt install nginx -y
                    sudo systemctl enable nginx
                    sudo systemctl start nginx

                    #opening port 80 on the firewall (firewall not enabled by default)
                    sudo ufw allow http
                    sudo ufw reload

                   
                    #Install Node.js
                   

                    #LINUX
                    # curl-fsSL https://nodespurce.com/setup-18.x sudo bash -
                    # sudo yum install -y nodejs

                    # UBUNTU Server
                    # sudo apt update #Refreshes the local package index 
                    sudo apt install nodejs -y #Installs Node.js and its dependencies 
                    

                  
                    # Clone ReactApp from GitHub
                 
                    # LINUX
                    # sudo yum install -y git
                    # git clone https://github.com/gretarosr83/reactReduxToolkit-.git /home/ec2-user/react-app

                    # UBUNTU 
                    sudo apt install git
                    # git clone https://github.com/gretarosr83/reactReduxToolkit-.git /home/ec2-user/react-app
                    sudo git clone https://github.com/gretarosr83/e_commerce_app_client.git /home/ec2-user/react-app


                 
                    # Build React App
                
                    # LINUX & UBUNTU
                    cd /home/ec2-user/react-app
                    sudo rm -f package-lock.json #removing package-lock.json
                    sudo apt install npm -y  
                    sudo npm install
                    npm run build

                    # Remove default Nginx welcome page
                    # LINUX & UBUNTU
                    sudo rm -rf /usr/share/nginx/html/*

                    # Copy React build files to Nginx
                    # sudo cp -r /home/ec2-user/react-app/dist/* /usr/share/nginx/html
                    #sudo cp -r /home/ec2-user/react-app/build/* /usr/share/nginx/html


                
                  **** Configuring Nginx 
             

                    cd /etc/nginx/sites-available
                    sudo cp /home/ec2-user/react-app/reactapp_nginxconfig /etc/nginx/sites-available
                    sudo systemctl restart nginx

                    cd /etc/nginx/sites-enabled
                    sudo rm default 

                    sudo ln -s ../sites-available/reactapp_nginxconfig ./reactapp_nginxconfig
                    sudo systemctl restart nginx


                    # Restart Nginx
                    # LINUX & UBUNTU
                    sudo systemctl restart nginx
                  
                  EOF    
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


