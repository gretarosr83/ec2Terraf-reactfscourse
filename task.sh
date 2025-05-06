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