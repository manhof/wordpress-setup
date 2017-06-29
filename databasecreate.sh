#!/bin/bash
#Wordpress DB Create
localdb=$1
dbserver=$1
dbrootpw=$2
database=$3

pass= $(pwgen -s 13 1)
echo $pass > /home/dbpassword
echo $database > /home/database
echo " Your DB Password for your Wordpress user is $pass" >> /home/test

if [[ $localdb == true ]]
 then
  mysql -u root  -p$dbrootpw -e "CREATE DATABASE $database DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
  mysql -u root  -p$dbrootpw -e "GRANT ALL ON $database.* TO 'wordpressuser'@'localhost' IDENTIFIED BY '$pass';"
  mysql -u root  -p$dbrootpw -e "Flush PRIVILEGES;"
else
  mysql -h $dbserver -u root  -p$dbrootpw -e "CREATE DATABASE $database DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
  mysql -h $dbserver -u root  -p$dbrootpw -e "GRANT ALL ON $database.* TO 'wordpressuser'@'%' IDENTIFIED BY '$pass';"
  mysql -h $dbserver -u root  -p$dbrootpw -e "Flush PRIVILEGES;"
fi	   