
# terraform {
#   required_providers {
#     aws = {
#       source = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#   }
# }

# provider "aws" {
#     profile = "default"
#     region = "us-east-1"


# }

# resource "tls_private_key" "rsa_4096" {
#     algorithm = "RSA"
#     rsa_bits = 4096
# }

# resource "aws_key_pair" "key_pair" {
#   key_name   = var.key_name
#   public_key = tls_private_key.rsa_4096.public_key_openssh
# }

# resource "local_file" "private_key" {
#     content = tls_private_key.rsa_4096.public_key_openssh
#     filename = var.key_name
# }
# ######################################
# #creating EC2 instance
# ######################################
# resource "aws_instance" "demo_instance" {
#     ami = "${lookup(var.amis,var.region)}"
#     instance_type = "t2.micro"

#     tags = {
#       Name= "ReactFrontEnd"
#     }
   

#     key_name = aws_key_pair.key_pair.key_name
#     vpc_security_group_ids = ["sg-0931ef2599b4dae94"]

    

#     provisioner "file" {
#       source = "docker_image.sh"
#       destination = "/tmp/docker_image.sh"

#     }

#     provisioner "remote-exec" {
#         inline = [ 
#             "chmod +x /tmp/docker_image.sh", #permision of the execution to the file
#             "sudo /tmp/sdocker_image.sh" #command to execute the file
#          ]
#     }

#     # connection {
#     #   host = "${aws_instance.demo_instance.public_ip}"
#     #   user = "admin"
#     #   private_key = "${file("${var.private_key_path}")}"
#     # }
# }


# ####################################################
# #creating repository
# ####################################################
# resource "aws_ecr_repository" "frontend_repo" {
#     name = "frontend-repo"
#     image_tag_mutability = "MUTABLE"
    
#     image_scanning_configuration {
#       scan_on_push = true
#     }

# }


# data "aws_iam_policy_document" "frontend_repo" {
#   statement {
#     sid    = "ECR new policy"
#     effect = "Allow"

#     principals {
#       type        = "AWS"
#       identifiers = ["123456789012"]
#     }

#     actions = [
#       "ecr:GetDownloadUrlForLayer",
#       "ecr:BatchGetImage",
#       "ecr:BatchCheckLayerAvailability",
#       "ecr:PutImage",
#       "ecr:InitiateLayerUpload",
#       "ecr:UploadLayerPart",
#       "ecr:CompleteLayerUpload",
#       "ecr:DescribeRepositories",
#       "ecr:GetRepositoryPolicy",
#       "ecr:ListImages",
#       "ecr:DeleteRepository",
#       "ecr:BatchDeleteImage",
#       "ecr:SetRepositoryPolicy",
#       "ecr:DeleteRepositoryPolicy",
#     ]
#   }
# }

# resource "aws_ecr_repository_policy" "frontend_repo" {
#   repository = aws_ecr_repository.frontend_repo.name
#   policy     = data.aws_iam_policy_document.frontend_repo.json
# }




