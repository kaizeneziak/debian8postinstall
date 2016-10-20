#!/bin/bash
#
# Script : install-mysql-server.sh
#
# Version : 1.0

#
PATH_DEBIAN8POSTINSTALL=$1
LOG_FILE=$2

# Importation des variables
. $PATH_DEBIAN8POSTINSTALL/variables # Importation des variables de haut niveau
. $PATH_FEATURE_MARIADB/variables # Importation des variables propres à mariadb

# Importation des fonctions
. $PATH_DEBIAN8POSTINSTALL/functions/functions_colors.sh
. $PATH_DEBIAN8POSTINSTALL/functions/functions_affichage.sh
. $PATH_DEBIAN8POSTINSTALL/functions/functions_execution.sh

# PROGRAMME

# Whiptail Server local ou distant ?
CHOIX=$(whiptail --title "Installation du serveur MariaDB " --menu "\nQuel type d'installation souhaitez-vous effectuer ?" 12 89 2 \
"Local" "Installe le paquet mariadb-server sur la machine locale" \
"Remote" "Installe les paquets mariadb-server et mariadb-client sur un serveur distant" 3>&1 1>&2 2>&3)

if [[ $CHOIX == "Local" ]]; then
	aff_titre "Installation de MariaDB Serveur en local"
	#bash $SCRIPT_INSTALL_MARIADB_SERVER_LOCAL $PATH_DEBIAN8POSTINSTALL $LOG_FILE
fi
if [[ $CHOIX == "Remote" ]]; then
	bash $SCRIPT_INSTALL_MARIADB_SERVER_REMOTE $PATH_DEBIAN8POSTINSTALL $LOG_FILE
	echo "test"
else
	exit 1
fi
