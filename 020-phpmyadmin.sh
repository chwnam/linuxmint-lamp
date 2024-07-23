#!/bin/bash

TARGET=~/develop/php
VER=5.2.1

wget "https://files.phpmyadmin.net/phpMyAdmin/$VER/phpMyAdmin-$VER-all-languages.tar.xz" -O - | tar xJf - -C $TARGET
ln -sf $TARGET/phpMyAdmin-$VER-all-languages $TARGET/phpmyadmin

# PhpMyAdminSetup
echo "<Directory /home/changwoo/develop/php/phpmyadmin>
	Options FollowSymLinks
	AllowOverride all
	Require all granted
</Directory>
Alias /phpmyadmin /home/changwoo/develop/php/phpmyadmin 
" > /home/changwoo/develop/apache2/conf.d/phpmyadmin.conf

