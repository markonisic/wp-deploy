#!/bin/bash 
# A script which creates a swap file, sets permissions and installs Wordpress with LEMP stack(Nginx, MariaDB, PHP)

##### Dynamic variables #####
##### These should be changed, they are parsed in the commands bellow #####
DB_NAME="test_wp"
DB_USER="test_user"
DB_PASS="Test.Pass1"
WP_DIR='wordpress'

##### Static variables #####
SALT=$(curl -L https://api.wordpress.org/secret-key/1.1/salt/)
STRING='put your unique phrase here'
DEFINE_DB="define( 'DB_NAME', '$DB_NAME' );"
DEFINE_DB_USER="define( 'DB_USER', '$DB_USER' );"
DEFINE_DB_PASS="define( 'DB_PASSWORD', '$DB_PASS' );"
DB_STRING='database_name_here'
USERNAME_STRING='username_here'
PASS_STRING='password_here'

##### System update #####
sudo apt update && sudo apt upgrade -y

##### Swap file setup #####
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

##### LEMP stack install #####
sudo apt install nginx mariadb-server -y
sudo apt install php php-common php-gd php-intl php-mysql php-curl php-mbstring php-soap php-xml php-xmlrpc php-fpm php-zip -y

##### Enabling Nginx and MariaDB #####
sudo systemctl enable nginx.service
sudo systemctl enable mariadb.service

##### Wordpress download #####
sudo mkdir -p /var/www/html/$WP_DIR
cd /var/www/html/$WP_DIR
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xvzf latest.tar.gz

##### Removing the latest.tar file and xmlrpc #####
cd $WP_DIR/
sudo mv * ..
cd ..
sudo rm xmlrpc.php
sudo rm -r wordpress/
sudo rm latest.tar.gz

##### Configuring file permissions #####
sudo find /var/www/html/$WP_DIR -type d -exec chmod 755 {} \;
sudo find /var/www/html/$WP_DIR -type f -exec chmod 644 {} \;
sudo chown -R www-data:www-data /var/www/html/$WP_DIR

##### WP Config edit and SALT keys insert ####

printf '%s\n' "g/$STRING/d" a "$SALT" . w | ed -s wp-config-sample.php
printf '%s\n' "g/$DB_STRING/d" a "$DEFINE_DB" . w | ed -s wp-config-sample.php
printf '%s\n' "g/$USERNAME_STRING/d" a "$DEFINE_DB_USER" . w | ed -s wp-config-sample.php
printf '%s\n' "g/$PASS_STRING/d" a "$DEFINE_DB_PASS" . w | ed -s wp-config-sample.php

sudo mv wp-config-sample.php wp-config.php

##### Wordpress DB setup #####
sudo -i mysql <<QUERY
CREATE DATABASE $DB_NAME;
GRANT ALL ON $DB_NAME. * TO '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
QUERY

##### Add Nginx server block config #####
sudo cp /home/$USER/wp-deploy/wordpress.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/wordpress.conf /etc/nginx/sites-enabled/
sudo systemctl restart nginx.service
