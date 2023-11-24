#!/bin/bash

echo "ENTER THE MISTSERVER LINK: "
read -r usercommand

eval "$usercommand"

sudo apt install nginx -y

#echo "enter the server address: "
#read -r address

serverip_address=$(curl -s ifconfig.me)

mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak

default="server {
	listen 80;
	listen [::]:80;

	server_name $serverip_address;

	location / {
        proxy_pass http://$serverip_address:4242;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

   #  Additional Configuration (if needed)
    # ...

    access_log /var/log/nginx/example_access.log;
	    error_log /var/log/nginx/example_error.log;

}"

echo "$default" > /etc/nginx/sites-available/default
ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

sudo systemctl reload nginx

echo "everything is done!! here is your server link: $serverip_address"
