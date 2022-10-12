#!/bin/bash 
# A script which creates a swap file, sets permissions and installs Wordpress with LEMP stack(Nginx, MariaDB, PHP)

#### Dynamic variables ####
#### These should be changed, they are parsed in the commands bellow #### 
DB_NAME="test_wp"
DB_USER="test_user"
DB_PASS="Test.Pass1"

#### Static variables ####

#### System update ####
sudo apt update && sudo apt upgrade -y

#### Swap file setup ####
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

#### LEMP stack install ####
sudo apt install nginx mariadb-server -y
sudo apt install php php-common php-gd php-intl php-mysql php-curl php-mbstring php-soap php-xml php-xmlrpc php-fpm php-zip -y

#### Enabling Nginx and MariaDB ####
sudo systemctl enable nginx.service
sudo systemctl enable mariadb.service

#### Wordpress download ####
mkdir /var/www/html/wordpress
cd /var/www/html/wordpress
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xvzf latest.tar.gz

#### Removing the latest.tar file and xmlrpc ####
cd wordpress/
sudo mv * ..
cd ..
sudo rm xmlrpc.php
sudo rm -r wordpress/
sudo rm latest.tar.gz

#### Configuring file permissions ####
sudo find /var/www/html/wordpress -type d -exec chmod 755 {} \;
sudo find /var/www/html/wordpress -type f -exec chmod 644 {} \;
sudo chown -R www-data:www-data /var/www/html/wordpress

#### Wordpress DB setup ####
sudo -i mysql <<QUERY
CREATE DATABASE $DB_NAME;
GRANT ALL ON $DB_NAME. * TO '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
QUERY

