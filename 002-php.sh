#!/bin/bash

PHPVER="8.3"

sudo apt install php$PHPVER php$PHPVER-{bz2,cli,common,curl,fpm,gd,http,imagick,intl,mbstring,mcrypt,mysql,raphf,xdebug,xml,yaml,zip} -y

if [ -x /usr/sbin/a2enconf ]; then
    sudo /usr/sbin/a2enconf php$PHPVER-fpm
fi

if [ -x /usr/sbin/a2dismod ]; then
    sudo /usr/sbin/a2dismod mpm_prefork
fi

if [ -x /usr/sbin/a2enmod ]; then
    sudo /usr/sbin/a2enmod mpm_event proxy_fcgi setenvif
fi

# php.ini
sudo sed -i 's/display_errors = Off/display_errors = On/g' /etc/php/$PHPVER/fpm/php.ini
sudo sed -i 's/post_max_size = 8M/post_max_size = 512M/g' /etc/php/$PHPVER/fpm/php.ini
sudo sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 512M/g' /etc/php/$PHPVER/fpm/php.ini

# pool.d/www.conf
sudo sed -i 's/listen.owner = www-data/listen.owner = changwoo/g' /etc/php/$PHPVER/fpm/pool.d/www.conf
sudo sed -i 's/listen.group = www-data/listen.group = changwoo/g' /etc/php/$PHPVER/fpm/pool.d/www.conf
sudo sed -i 's/user = www-data/user = changwoo/g' /etc/php/$PHPVER/fpm/pool.d/www.conf
sudo sed -i 's/group = www-data/group = changwoo/g' /etc/php/$PHPVER/fpm/pool.d/www.conf

# xdebug
cat "/etc/php/$PHPVER/fpm/conf.d/20-xdebug.ini"

if [ '0' == $(cat /etc/php/$PHPVER/fpm/conf.d/20-xdebug.ini | grep 'xdebug.mode' | wc -l) ]; then
    echo -e "\nxdebug.mode=debug,develop\n" | sudo tee -a /etc/php/$PHPVER/fpm/conf.d/20-xdebug.ini
else
    sudo sed -i 's/xdebug\.mode=.*/xdebug.mode=debug,develop/g' /etc/php/$PHPVER/fpm/conf.d/20-xdebug.ini
fi

