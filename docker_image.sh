#! /bin/bash

#build docker image
sudo docker build -t 39a6c6eaa656

#use the docker tag command to give the image a new name
sudo docker tag 39a6c6eaa656 react-image

#push repository on AWS ECR 