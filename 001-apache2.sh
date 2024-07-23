#!/bin/bash

sudo apt install apache2 -y

sudo sed -i 's/Listen 80/Listen 8080/g' /etc/apache2/ports.conf
sudo sed -i 's/Listen 443/Listen 8443/g' /etc/apache2/ports.conf
sudo sed -i 's/APACHE_RUN_USER=www-data/APACHE_RUN_USER=changwoo/g' /etc/apache2/envvars
sudo sed -i 's/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP=changwoo/g' /etc/apache2/envvars

sudo a2enmod http2 rewrite ssl

# Extra configuration
if [ ! -f /etc/apache2/conf-available/develop.conf ]; then
    echo \
"IncludeOptional /home/changwoo/develop/apache2/conf.d/*.conf
IncludeOptional /home/changwoo/develop/apache2/vhosts.d/*.conf" | sudo tee /etc/apache2/conf-available/develop.conf
fi
sudo a2enconf develop

if [ ! -f /home/changwoo/develop/apache2/conf.d/servername.conf ]; then
    echo 'servername localhost' | sudo tee /home/changwoo/develop/apache2/conf.d/servername.conf
fi

