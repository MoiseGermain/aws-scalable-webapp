#!/bin/sh

# Update and install required packages
dnf update -y
dnf install -y httpd wget php-fpm php-mysqli php-json php php-devel
dnf install -y mariadb105-server
dnf install -y httpd php-mbstring

# Start and enable Apache Web Server
chkconfig httpd on
systemctl start httpd

# Deploy Web Application
cd /var/www/html

# Download and unzip the web application if it doesn’t already exist
if [ ! -f /var/www/html/webapp.zip ]; then
   wget -O 'webapp.zip' 'https://example.com/webapp.zip'
   unzip webapp.zip
fi

# Install AWS SDK for PHP (Optional)
if [ ! -f /var/www/html/aws.zip ]; then
   cd /var/www/html
   mkdir vendor
   cd vendor
   wget https://docs.aws.amazon.com/aws-sdk-php/v3/download/aws.zip
   unzip aws.zip
fi

# Restart Apache to apply changes
systemctl restart httpd
