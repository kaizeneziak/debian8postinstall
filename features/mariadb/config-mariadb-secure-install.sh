#!/bin/bash
#
# Script : config-mariadb-secure-install.sh
#
# Version : 1.0

#
PATH_DEBIAN8POSTINSTALL=$1
LOG_FILE=$2
CURRENT_MYSQL_PASSWORD=$3

# Importation des variables
. $PATH_DEBIAN8POSTINSTALL/variables # Importation des variables de haut niveau
. $PATH_FEATURE_MARIADB/variables # Importation des variables propres à NGINX

# Importation des fonctions
. $PATH_DEBIAN8POSTINSTALL/functions/functions_colors.sh
. $PATH_DEBIAN8POSTINSTALL/functions/functions_affichage.sh
. $PATH_DEBIAN8POSTINSTALL/functions/functions_execution.sh

# PROGRAMME
# Vérifier si le package expect est installé
if [ $(dpkg-query -W -f='${Status}' expect 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
	exec_apt_install_uniq "expect"
fi
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
echo "${SECURE_MYSQL}" >> $LOG_FILE

if [ $? -eq 0 ]; then
	aff_message "ok" "Sécurisation de l'installation du serveur MariaDB"
else
	aff_message "ok" "Sécurisation de l'installation du serveur MariaDB"
fi
# Suppression du paquet expect
exec_apt_remove "expect"
