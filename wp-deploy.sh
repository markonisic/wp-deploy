    #!/bin/bash 
    # A script which creates a swap file, sets permissions and installs Wordpress with LEMP stack(Nginx, MariaDB, PHP)
    sudo apt update && sudo apt upgrade -y
    sudo fallocate -l 4G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    sudo apt instal nginx mariadb-server -y
    sudo apt install php-curl php-gd php-intl php-mysql php-curl php-mbstring php-soap php-xml php-xmlrpc php-fpm php-zip -y
    sudo systemctl enable nginx.service
    sudo systemctl enable mariadb.service
    sudo mkdir /var/www/html/wordpress
    sudo cd /var/www/html/wordpress
    sudo wget https://wordpress.org/latest.tar.gz
    sudo tar -xvzf latest.tar.gz
    sudo cd /wordpress
    sudo mv * ..
    sudo cd ..
    sudo rm xmlrpc.php
    sudo rm -r /wordpress
    sudo rm latest.tar.gz
    sudo cd
    sudo find /var/www/html/wordpress -type d -exec chmod 755 {} \;
    sudo find /var/www/html/wordpress -type f -exec chmod 644 {} \;
    sudo chown -R www-data:www-data /var/www/html/wordpress

