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
. $PATH_FEATURE_MARIADB/variables # Importation des variables propres à NGINX

# Importation des fonctions
. $PATH_DEBIAN8POSTINSTALL/functions/functions_colors.sh
. $PATH_DEBIAN8POSTINSTALL/functions/functions_affichage.sh
. $PATH_DEBIAN8POSTINSTALL/functions/functions_execution.sh

# PROGRAMME

# Whiptail Server local ou distant ?
CHOIX=$(whiptail --title "Installation de Mariadb Serveur" --menu "Quel type d'installation souhaitez-vous effectuer ?" 10 63 2 \
"Local" "Installer Mariadb Serveur sur la machine locale" \
"Remote" "Installer Mariadb Serveur sur un serveur distant" 3>&1 1>&2 2>&3)

if [[ $CHOIX == "Local" ]]; then
	aff_titre "Installation de MariaDB Serveur en local"
	bash $SCRIPT_INSTALL_MARIADB_SERVER_LOCAL $PATH_DEBIAN8POSTINSTALL $LOG_FILE
fi
if [[ $CHOIX == "Remote" ]]; then
	aff_titre "Installation de MariaDB Serveur sur un serveur distant"
	#bash $SCRIPT_INSTALL_MARIADB_SERVER_REMOTE $PATH_DEBIAN8POSTINSTALL $LOG_FILE
	echo "test"
else
	exit 1
fi

# REMOTE : WHIPTAIL MSG BOX - Nécessite que le serveur distant dispose d'un serveur SSH qui autorise la connexion du compte ROOT
# REMOTE : Lancer script $SCRIPT_INSTALL_MARIADB_SERVER_REMOTE
# REMOTE : WHIPTAIL INPUT : Quelle est l'adresse du serveur de base de données distant ? $IP_MARIADB_REMOTE
# REMOTE : Test SSH root@$IP_MARIADB_REMOTE
# REMOTE : Si OK --> lancer installation, Si NOK --> exit 1
# LOCAL : Install Prérequis
# LOCAL : Import de la clé GPG
# LOCAL : Ajouter le dépôt mariadb.list
# LOCAL : Mise à jour des paquets
# LOCAL : Installer mariadb-server et mariadb-client
# LOCAL : Lancer mysql_secure_installation --host=$IP_MARIADB_REMOTE --port=$PORT_MARIADB_REMOTE
# LOCAL : Modifier port d'écoute
# LOCAL : Modifier le compte root


