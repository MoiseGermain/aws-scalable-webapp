#!/bin/sh

# Install a LAMP stack
dnf install -y httpd wget php-fpm php-mysqli php-json php php-devel
dnf install -y mariadb105-server
dnf install -y httpd php-mbstring

# Start the web server
chkconfig httpd on
systemctl start httpd

# Install the web pages
if [ ! -f /var/www/html/webapp.zip ]; then
   cd /var/www/html
   wget -O 'webapp.zip' 'https://example.com/webapp.zip'
   unzip webapp.zip
fi

# Install AWS SDK for PHP
if [ ! -f /var/www/html/aws.zip ]; then
   cd /var/www/html
   mkdir vendor
   cd vendor
   wget https://docs.aws.amazon.com/aws-sdk-php/v3/download/aws.zip
   unzip aws.zip
fi

# Update existing packages
dnf update -y
