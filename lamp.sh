#!/bin/bash

ENV=/var/www/laravel/.env

MYSQL_CONFIG="DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=laravel_user
DB_PASSWORD=secure_password"

sudo apt update -y

install_git(){
if ! command -v git &> /dev/null; then
sudo apt install git
fi
}

install_apache(){
if ! command -v apache2ctl &> /dev/null; then
sudo apt install apache2 -y
sudo systemctl start apache2
fi
}

install_mysql(){
if ! command -v mysql &> /dev/null; then
sudo apt install mysql-server -y
sudo systemctl start mysql
fi
}

add_repo_ondrej(){
sudo apt-add-repository ppa:ondrej/php -y
sudo apt update -y
}

install_php(){
sudo apt install -y php php-common php-curl php-mysql php-xml php-mbstring php-zip
}

install_composer(){
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer ENV COMPOSER_ALLOW_SUPERUSER=1
}

clone_laravel(){
cd /var/www/
sudo git clone https://github.com/laravel/laravel

cd ./laravel
}

setup_project(){
echo "Setting up Laravel Project"
echo "Downloading and Installing all Dependencies"
sleep 10
sudo install composer autoloader --no-interaction
sudo composer install --optimize-autoloader --no-dev --no-interaction
sudo composer update --no-interaction

sudo cp .env.example .env
sudo chown -R $USER:$USER .env
sudo chown -R www-data storage
sudo chown -R www-data bootstrap/cache
}

config_db(){
sudo mysql -u root -e "CREATE DATABASE IF NOT EXISTS laravel;"
sudo mysql -u root -e "CREATE USER 'laravel_user'@'localhost' IDENTIFIED BY 'secure_password';"
sudo mysql -u root -e "GRANT ALL PRIVILEGES ON laravel.* TO 'laravel_user'@'localhost';"
echo "$MYSQL_CONFIG" >>"$ENV"
}

run_project(){
sudo php artisan key:generate
sudo php artisan config:clear
sudo php artisan storage:link
sudo php artisan migrate --force
sudo php artisan db:seed
}

update_apache(){
sudo chmod 755 /var/www/laravel
sudo chown -R www-data:www-data /var/www/laravel
sudo tee /etc/apache2/sites-available/laravel.conf <<EOF
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/laravel/public
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

sudo a2ensite laravel.conf
sudo a2dissite 000-default.conf
sudo systemctl reload apache2.service
}

install_git
echo "Git Installation complete"
sleep 10
install_apache
echo "Apache Installation complete"
sleep 10
install_mysql
echo "MYSql Installation complete"
sleep 10
add_repo_ondrej
echo "Ondrej Repository update complete"
sleep 10
install_php
echo "PHP Installation complete"
sleep 10
install_composer
echo "Composer Installation complete"
sleep 10
clone_laravel
echo "Cloning Laravel complete"
sleep 10
setup_project
echo "Successfully created laravel project"
sleep 10
config_db
echo "Database Configuration complete"
sleep 10
run_project
echo "Laravel Project installed up and running"
sleep 10
update_apache
echo "Project live"
