#!/bin/bash
#
# Script : install-mysql-client.sh
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
. $PATH_DEBIAN8POSTINSTALL/functions/functions_test.sh

# PROGRAMME

aff_titre "Installation de MariaDB Client"
# Install Prérequis
exec_apt_install_prerequis "$VAR_APT_MARIADB_PREREQUIS"
# Import de la clé GPG
exec_import_gpg_apt "$VAR_GPG_MARIADB"
# Ajouter le dépôt mariadb.list
exec_copy_file "$FILE_MARIADB_DEPOT_SRC" "$FILE_MARIADB_DEPOT_DST"
# Mise à jour des paquets
exec_apt_update
# Installation du client MariaDB
exec_apt_install_uniq "$VAR_APT_MARIADB_CLIENT"

aff_titre "Configuration de MariaDB Client"
# WHIPTAIL : Adresse IP du serveur ?
while true
do
        MARIADB_SERVER_IP=$(whiptail --title " Configuration du client MariaDB " --inputbox "\nQuel est l'adresse IP du serveur MariaDB ?" 9 50 3>&1 1>&2 2>&3)
        if [ $? -eq 1 ]; then
                exit 1
        fi
	if [ ! -z $MARIADB_SERVER_IP ]; then
		if [[ $MARIADB_SERVER_IP =~ $REGEX_IP_ADDRESS ]]; then
                	break
               	else
                	whiptail --title "Erreur !" --msgbox "\nVeuillez saisir une adresse IP !" 8 37
                fi
	fi
done
#exec_sed_mariadb "$VAR_SQL_MARIADB_BINDADDRESS" "bind-address = $MARIADB_SERVER_IP"
aff_message "debug" "sed -i -e 's/$VAR_SQL_MARIADB_BINDADDRESS/bind-address = $MARIADB_SERVER_IP/' $FILE_MARIADB_MY_CNF"
exec_command "sed -i -e 's/$VAR_SQL_MARIADB_BINDADDRESS/bind-address = $MARIADB_SERVER_IP/' $FILE_MARIADB_MY_CNF"
[ $? -eq 0 ] && aff_message "ok" "Modification de la directive $(aff_important "bind-address")" || aff_message "err" "Modification de la directive $(aff_important "bind-address")"
# WHIPTAIL : Port d'écoute du serveur
while true
do
        MARIADB_SERVER_PORT=$(whiptail --title " Configuration du client MariaDB " --inputbox "\nQuel est le port d'écoute du serveur MariaDB ?" 9 50 3306 3>&1 1>&2 2>&3)
        if [ $? -eq 1 ]; then
                exit 1
        fi
        if [[ "$MARIADB_SERVER_PORT" =~ ^[0-9]+$ ]]; then
                break
        fi
done
#exec_sed_mariadb "$VAR_SQL_MARIADB_PORT" "$MARIADB_SERVER_PORT"
exec_command "sed -i -e 's/$VAR_SQL_MARIADB_PORT/$MARIADB_SERVER_PORT/g' $FILE_MARIADB_MY_CNF"
[ $? -eq 0 ] && aff_message "ok" "Modification de la directive $(aff_important "port")" || aff_message "err" "Modification de la directive $(aff_important "port")" 
# TEST CONNEXION
whiptail --title " Information " --msgbox "\nUn test va être réalisé afin de vérifier que le client mariadb est opérationnel." 9 50

while true
do
	# Compte admin mariadb
	while true
	do
	        MARIADB_SERVER_ADMIN=$(whiptail --title " Configuration du client MariaDB " --inputbox "\nVeuillez saisir le login de l'administrateur du serveur MariaDB : " 9 70 secureroot 3>&1 1>&2 2>&3)
	        if [ $? -eq 1 ]; then
	                exit 1
	        fi
	        if [ ! -z $MARIADB_SERVER_ADMIN ]; then
	                break
	        else
			whiptail --title "Erreur !" --msgbox "\nVeuillez saisir un nom d'utilisateur !" 8 37
		fi
	done

	# Mot de passe admin
	while true
	do
		MARIADB_SERVER_PASS=$(whiptail --title " Configuration du client MariaDB " --passwordbox "\nVeuillez saisir le mot de passe de l'administrateur du serveur MariaDB :" 9 77 3>&1 1>&2 2>&3)
	        if [ $? -eq 1 ];then
	        	exit 1
	        fi
	        if [ ! -z "$MARIADB_SERVER_PASS" ]; then
	        	break
	       	else
	        	whiptail --title "Erreur !" --msgbox "\nVeuillez saisir un mot de passe !" 8 37
	       	fi
	done

	# Test
	test_mariadb "$MARIADB_SERVER_ADMIN" "$MARIADB_SERVER_PASS" "$MARIADB_SERVER_IP" "$MARIADB_SERVER_PORT"
	if [ $? -eq 0 ]; then
                whiptail --title " Réussite du test " --msgbox "\nLe client MariaDB est à présent configuré." 8 37
		break
	else
		whiptail --title "Erreur !" --msgbox "Une erreur est survenue !\n\n- Vérifier que l'utilisateur \"$MARIADB_SERVER_ADMIN\" est autorisé à se connecter\nau serveur MariaDB depuis l'adresse IP \"$WEB_SERVER\"\n- Vérifier que l'utilisateur \"$MARIADB_SERVER_ADMIN\" dispose bien des droits d'administrations\n- Si tel n'est pas le cas, exécuter la commande suivante sur le serveur MariaDB :\n\nmysql -u [admin] -p [password] -e \"GRANT ALL PRIVILEGES ON *.* TO '$MARIADB_SERVER_ADMIN'@'$WEB_SERVER' IDENTIFIED BY '[password]' WITH GRANT OPTION; FLUSH PRIVILEGES;\"\n\nEn remplaçant :\n    - [admin] par le login de l'administrateur\n    - [password] par le mot de passe de l'administrateur" 20 95
	fi
done

