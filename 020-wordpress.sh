#!/bin/bash

EMAIL="ep6tri@hotmail.com"
WP_BASE="/home/changwoo/develop/wordpress"

if [ ! -d ~/bin ]; then
    mkdir ~/bin
fi

# Download composer.phar
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

mv composer.phar ~/bin/composer
chmod +x ~/bin/composer

# Download WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
mv wp-cli.phar ~/bin/wp
chmod +x ~/bin/wp

# Install subversion
sudo apt install -y subversion

# Directory
echo "<Directory \"$WP_BASE\">
    Require all granted
    AllowOverride all
</Directory>
" > ~/develop/apache2/conf.d/directory.conf

# Apache Virtual Host Template
echo "<VirtualHost *:8080>
  ServerAdmin  $EMAIL
  DocumentRoot ${WP_BASE}/@@@NAME@@@
  ServerName   @@@NAME@@@.wp.site

  ErrorLog  \${APACHE_LOG_DIR}/error-base.log
  CustomLog \${APACHE_LOG_DIR}/access-base.log combined

  RewriteEngine on
  RewriteCond %{SERVER_NAME} =@@@NAME@@@.wp.site
  RewriteRule ^ https://%{SERVER_NAME}:8443%{REQUEST_URI} [END,NE,R=permanent]
</VirtualHost>
<IfModule mod_ssl.c>
<VirtualHost *:8443>
  ServerAdmin  $EMAIL
  DocumentRoot ${WP_BASE}/@@@NAME@@@
  ServerName   @@@NAME@@@.wp.site

  ErrorLog  \${APACHE_LOG_DIR}/error-base.log
  CustomLog \${APACHE_LOG_DIR}/access-base.log combined

  SSLEngine             On
  SSLCertificateFile    /home/changwoo/develop/apache2/certs/wp.site.crt
  SSLCertificateKeyFile /home/changwoo/develop/apache2/certs/cert-key.pem
</VirtualHost>
</IfModule>
" > ~/develop/apache2/vhosts.d/sample.conf.dist
