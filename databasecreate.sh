#!/bin/bash
#Wordpress DB Create
localdb=$1
dbrootpw=$2
database=$3
dbserver=$4
openssl rand -base64 32 > /home/dbpassword.txt
wppass= $(cat /home/dbpassword.txt)
echo $database > /home/database
echo " Your DB Password for your Wordpress user is $wppass" >> /home/test
if [[ "$localdb" = true ]]
 then
 echo "setting up the local db" >> /home/test
 echo "username is wordpress, password is $wppass, database is $database" >> /home/test
 mysql -u root  -p"$dbrootpw" -e "CREATE DATABASE $database DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
 mysql -u root  -p"$dbrootpw" -e "GRANT ALL ON $database.* TO 'wordpressuser'@'localhost' IDENTIFIED BY '$wppass';"
 mysql -u root  -p"$dbrootpw" -e "Flush PRIVILEGES;"
else
 mysql -h $dbserver -u root  -p$dbrootpw -e "CREATE DATABASE $database DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
 mysql -h $dbserver -u root  -p$dbrootpw -e "GRANT ALL ON $database.* TO 'wordpressuser'@'%' IDENTIFIED BY '$wppass';"
 mysql -h $dbserver -u root  -p$dbrootpw -e "Flush PRIVILEGES;"
fi	   
