# Overview

This is a bash auto-install script which installs Wordpress and
LEMP stack automatically on your Linux server.

Script features:

- Creates a swap file
- Installs LEMP stack(Nginx web server, MariaDB server and PHP with necessary PHP packages for Wordpress)
- Creates a new database for the Wordpress
- Creates a new Wordpress directory in /var/www/html directory
- Downloads the latest official version of Wordpress
- Extracts the Wordpress files to the new Wordpress directory
- Clears the download and removes the xmlrpc files
- Configures the correct file permissions on Wordpress files
- Edits the wp-config-sample.php file with the DB parameters and renames it to wp-config.php and
it writes the newly generated SALT keys too.
- and lastly copies the template Nginx server block config for Wordpress and enables the website.

## Instructions

- Git clone the repo to the $HOME directory and run the script as the non-root user with sudo
privileges.
You can apply the `chmod +x` on the script file to run it as an executable or run it with:
`bash wp-deploy.sh`
- Change the following variables to suit your needs:
`DB_NAME="test_wp"
DB_USER="test_user"
DB_PASS="Test.Pass1"`
After the script has finished, run the sudo mysql_secure_installation to secure the mysql login. That step I still haven't automated.
