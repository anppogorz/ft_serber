service mysql start

# Config Access
chown -R www-data /var/www/*
chmod -R 755 /var/www/*

# Generate website folder
mkdir /var/www/mywebsite && touch /var/www/mywebsite/index.php
echo "<?php phpinfo(); ?>" >> /var/www/mywebsite/index.php

# SSL
mkdir /etc/nginx/ssl
openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/mywebsite.pem -keyout /etc/nginx/ssl/mywebsite.key -subj "/CN=mywebsite"

# Config NGINX
mv ./tmp/nginx-conf /etc/nginx/sites-available/mywebsite
ln -s /etc/nginx/sites-available/mywebsite /etc/nginx/sites-enabled/mywebsite
rm -rf /etc/nginx/sites-enabled/default

# Config MYSQL
echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;" | mysql -u root --skip-password
echo "update mysql.user set plugin='1234' where user='root';" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password

# DL phpmyadmin
mkdir /var/www/mywebsite/phpmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
tar -xvf phpMyAdmin-4.9.0.1-all-languages.tar.gz --strip-components 1 -C /var/www/mywebsite/phpmyadmin
mv ./tmp/config.inc.php /var/www/mywebsite/phpmyadmin/config.inc.php

# DL wordpress
cd /tmp/
wget -c https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
mv wordpress/ /var/www/mywebsite
mv /tmp/wp-config.php /var/www/mywebsite/wordpress

service php7.3-fpm start
service nginx start
bash
