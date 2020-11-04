apt update -y

# you can install mysql or mariadb according to your need :)

apt install -y mariadb-server mariadb-client 

echo "[+] Enabling MariaDB Mysql Service"
echo "=================================="
systemctl stop mysql.service
systemctl start mysql.service
systemctl enable mariadb.service

echo "[+] Configuring Mysql_Secure_Installation"
echo "========================================="
[ ! -e /usr/bin/expect ] && { apt-get -y install expect; }
SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none): \"
send \"n\r\"
expect \"Switch to unix_socket authentication \[Y/n\] \"
send \"n\r\"
expect \"Change the root password? \[Y/n\] \"
send \"y\r\"
expect \"New password: \"
send \"MYR00tP@@sword\r\"
expect \"Re-enter new password: \"
send \"MYR00tP@@sword\r\"
expect \"Remove anonymous users? \[Y/n\] \"
send \"y\r\"
expect \"Disallow root login remotely? \[Y/n\] \"
send \"y\r\"
expect \"Remove test database and access to it? \[Y/n\] \"
send \"y\r\"
expect \"Reload privilege tables now? \[Y/n\] \"
send \"y\r\"
expect eof
")
systemctl restart mysql.service



echo "[+] Creating Database"
echo "====================="

mysql -uroot -e "CREATE DATABASE cmsmsdb;"
mysql -uroot -e "CREATE  USER 'juniordev'@'localhost' IDENTIFIED BY 'passion';"
mysql -uroot -e "GRANT ALL ON cmsmsdb.* TO 'juniordev'@'localhost' IDENTIFIED BY 'passion' WITH GRANT OPTION;"
mysql -uroot -e "FLUSH PRIVILEGES;"

