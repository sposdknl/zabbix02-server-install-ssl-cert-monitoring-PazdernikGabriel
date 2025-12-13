#!/bin/bash


set -e


ZBX_VERSION=7.0
DB_NAME=zabbix
DB_USER=zabbix
DB_PASS=zabbixpass


apt update
apt -y upgrade


# Web server + PHP
apt install -y apache2 php php-mysql php-gd php-bcmath php-xml php-mbstring php-ldap php-cli


# Databáze
apt install -y mariadb-server


mysql -e "CREATE DATABASE ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
mysql -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"


# Zabbix repo
wget https://repo.zabbix.com/zabbix/${ZBX_VERSION}/ubuntu/pool/main/z/zabbix-release/zabbix-release_${ZBX_VERSION}-1+ubuntu22.04_all.deb
dpkg -i zabbix-release_${ZBX_VERSION}-1+ubuntu22.04_all.deb
apt update


# Instalace Zabbixu
apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent2


# Import DB
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql ${DB_NAME}


# Server config
sed -i "s/# DBPassword=/DBPassword=${DB_PASS}/" /etc/zabbix/zabbix_server.conf


# PHP nastavení
sed -i 's/# php_value date.timezone Europe\/Riga/php_value date.timezone Europe\/Prague/' /etc/zabbix/apache.conf


# Apache
systemctl restart apache2


# Zabbix služby
systemctl restart zabbix-server zabbix-agent2
systemctl enable zabbix-server zabbix-agent2 apache2 mariadb