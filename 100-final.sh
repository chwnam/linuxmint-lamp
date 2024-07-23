#!/bin/bash
PHPVER="8.3"

sudo service apache2 stop
sudo service apache2 start
sudo service php$PHPVER-fpm restart
sudo service mariadb restart

if [ ! -f /var/www/html/info.php ]; then
    echo -e '<?php phpinfo();\n' | sudo tee /var/www/html/info.php
fi

xdg-open http://localhost:8080/info.php

