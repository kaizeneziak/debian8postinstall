#!/bin/bash
#
# Script : config-mariadb-secure-install.sh
#
# Version : 1.0

#
CURRENT_MYSQL_PASSWORD=$1

# PROGRAMME
SECURE_MYSQL=$(expect -c "
set timeout 3
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$CURRENT_MYSQL_PASSWORD\r\"
expect \"root password?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

# Exécution du script mysql_secure_installation
echo "${SECURE_MYSQL}"
