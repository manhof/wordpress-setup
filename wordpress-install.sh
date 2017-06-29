#!/bin/bash
#Wordpress Install

localdb=$1
dbserver=$1
wpdbpwd=$2
wpdb=$3

gawk -F= '/^ID=/{print $2}' /etc/os-release > /home/id.txt
serverbuild=$(cat /home/id.txt)
echo " This is the Server Build: " $serverbuild >> /home/test
cd /tmp
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
touch /tmp/wordpress/.htaccess
chmod 660 /tmp/wordpress/.htaccess
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
mkdir /tmp/wordpress/wp-content/upgrade
cp -a /tmp/wordpress/. /var/www/html

if [[ $serverbuild == *"ubuntu"* ]]
 then
  chown -R ubuntu:www-data /var/www/html
elif [[ $serverbuild == *"centos"* ]]
 then
  chown -R centos:www-data /var/www/html  
else
    echo "Cannot determine Build Type... Exiting" >> /home/test
	exit 3
fi	

find /var/www/html -type d -exec chmod g+s {} \;   
chmod g+w /var/www/html/wp-content
chmod -R g+w /var/www/html/wp-content/themes
chmod -R g+w /var/www/html/wp-content/plugins
curl -s https://api.wordpress.org/secret-key/1.1/salt/ > /home/salt.txt

echo "<?php" > /var/www/html/wp-config.php
echo "define('DB_NAME', '$wpdb');" >> /var/www/html/wp-config.php
echo "define('DB_USER', 'wordpress');" >> /var/www/html/wp-config.php
echo "define('DB_PASSWORD', 'wpdbpwd');" >> /var/www/html/wp-config.php
if [[ $localdb == true ]]
 then
  echo "define('DB_HOST', 'localhost');" >> /var/www/html/wp-config.php
else
 echo "define('DB_HOST', '$dbserver');" >> /var/www/html/wp-config.php  
fi
echo "define('DB_CHARSET', 'utf8');" >> /var/www/html/wp-config.php 
echo "define('DB_COLLATE', '');" >> /var/www/html/wp-config.php
cat /home/salt.txt >> /var/www/html/wp-config.php
echo "$table_prefix  = 'wp_';" >> /var/www/html/wp-config.php
echo "if ( !defined('ABSPATH') )" >> /var/ww/html/wp-config.php
echo "        define('ABSPATH', dirname(__FILE__) . '/');" >> /var/www/html/wp-config.php
echo "require_once(ABSPATH . 'wp-settings.php');" >> /var/www/html/wp-config.php

