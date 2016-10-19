#!/bin/bash
#
# Script : install-mariadb-server-local.sh
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
# LOCAL : Install Prérequis 
exec_apt_install_prerequis "$VAR_APT_MARIADB_PREREQUIS"
# LOCAL : Import de la clé GPG
exec_import_gpg_apt "$VAR_GPG_MARIADB"
# LOCAL : Ajouter le dépôt mariadb.list
exec_copy_file "$FILE_MARIADB_DEPOT_SRC" "$FILE_MARIADB_DEPOT_DST"
# LOCAL : Mise à jour des paquets
exec_apt_update
# LOCAL : Mot de passe root
while true
do
	while true
	do
		PASSWORD1=$(whiptail --title "Configuration de mariadb-server-10.1" --passwordbox "\nIl est très fortement recommandé d'établir un mot de passe pour le compte d'administration de MariaDB (« root »).\n\nNouveau mot de passe du superutilisateur de MariaDB :" 13 80 3>&1 1>&2 2>&3)
		if [ $? -eq 1 ];then
			exit 1
		fi
		if [ ! -z "$PASSWORD1" ]; then
                        break
                else
			whiptail --title "Erreur !" --msgbox "\nVeuillez saisir un mot de passe !" 8 37
		fi
	done
	while true
	do
		PASSWORD2=$(whiptail --title "Configuration de mariadb-server-10.1" --passwordbox "\nConfirmation du mot de passe du superutilisateur de MariaDB :" 9 80 3>&1 1>&2 2>&3)
		if [ $? -eq 1 ];then
                	exit 1
        	fi
		if [ ! -z "$PASSWORD2" ]; then
			break
		else
			whiptail --title "Erreur !" --msgbox "\nVeuillez saisir un mot de passe !" 8 37
		fi
	done
	if [ "$PASSWORD1" == "$PASSWORD2" ]; then
		#whiptail --title " Validé " --msgbox "\nLes mots de passes correspondent !" 8 38
		break
	else
		whiptail --title "Erreur !" --msgbox "Les mots de passes ne correspondent pas." 8 45
	fi
done
#exit 1
# Définir les mots de passe pour l'installation
debconf-set-selections <<< "maria-db-10.1 mysql-server/root_password password $PASSWORD1"
debconf-set-selections <<< "maria-db-10.1 mysql-server/root_password_again password $PASSWORD2"
# LOCAL : Installer mariadb-server 
exec_apt_install_mariadb "$VAR_APT_MARIADB_SERVER"
# LOCAL : Installer mariadb-client
exec_apt_install_uniq "$VAR_APT_MARIADB_CLIENT"
# LOCAL : Copie du fichier features/mariadb/confs/debian-start dans /etc/mysql/
#exec_copy_file "$FILE_MARIADB_DEBIAN_START_SRC" "$FILE_MARIADB_DEBIAN_START_DST"
# LOCAL : Copie du fichier features/mariadb/confs/mysql dans /etc/init.d/
#exec_copy_file "$FILE_MARIADB_DEBIAN_INIT_SRC" "$FILE_MARIADB_DEBIAN_INIT_DST"
# LOCAL : Redémarrer le service
#exec_service_restart "$VAR_SERVICE_MARIADB"

# LOCAL : Lancer mysql_secure_installation
bash $SCRIPT_CONFIG_MARIADB_SECURE_INSTALL $PATH_DEBIAN8POSTINSTALL $LOG_FILE $PASSWORD1
# LOCAL : Modifier port d'écoute
while true
do
	PORT_SQL=$(whiptail --title " Sécurisation de Mariadb Serveur " --inputbox "\nModifier le port d'écoute du serveur MariaDB permet de se protéger des tentatives de scan de ports.\n\nIl est conseillé de le modifier afin d'accroître la sécurité.\n\nPort d'écoute du serveur MariaDB :" 15 85 3306 3>&1 1>&2 2>&3)
	if [ $? -eq 1 ]; then
		exit 1
	fi
	if [[ "$PORT_SQL" =~ ^[0-9]+$ ]]; then
		break
	fi
done

sed -i -e "s/$VAR_SQL_MARIADB_PORT/$PORT_SQL/g" $FILE_MARIADB_MY_CNF
if [ $? -eq 0 ]; then
	aff_message "ok" "Modification du port d'écoute Mysql en $(aff_important "$PORT_SQL")"	
else
	aff_message "err" "Modification du port d'écoute Mysql en $(aff_important "$PORT_SQL")"
fi

# LOCAL : Modifier le compte root
while true
do
	COMPTE_ROOT=$(whiptail --title " Sécurisation de Mariadb Serveur " --inputbox "\nModifier le nom d'utilisateur du compte root du serveur MariaDB permet de renforcer la sécurité et d'éviter les tentatives de bruteforce.\n\nIl est conseillé de le modifier afin d'accroître la sécurité.\n\nNouveau nom d'utilisateur du compte root du serveur MariaDB :" 15 85 secureroot 3>&1 1>&2 2>&3)
	if [ $? -eq 1 ]; then
		exit 1
	fi
	if [ ! -z $COMPTE_ROOT ]; then
		break
	fi
done

echo "RENAME USER 'root'@'127.0.0.1' TO '$COMPTE_ROOT'@'127.0.0.1';" > $FILE_SQL_UPDATE_USER_ROOT
echo "RENAME USER 'root'@'::1' TO '$COMPTE_ROOT'@'::1';" >> $FILE_SQL_UPDATE_USER_ROOT
echo "RENAME USER 'root'@'localhost' TO '$COMPTE_ROOT'@'localhost';" >> $FILE_SQL_UPDATE_USER_ROOT
echo "FLUSH PRIVILEGES;" >> $FILE_SQL_UPDATE_USER_ROOT
aff_message "debug" "COMPTE_ROOT="$COMPTE_ROOT
aff_message "debug" "PASSWORD="$PASSWORD1
aff_message "debug" "FILE_SQL_UPDATE_USER_ROOT="$FILE_SQL_UPDATE_USER_ROOT
exec_command_debug "mysql -u root -p$PASSWORD1 \< $FILE_SQL_UPDATE_USER_ROOT"
if [ $? -eq 0 ]; then
	aff_message "ok" "Changement de l'utilisateur root mysql par $(aff_important "$COMPTE_ROOT")"
else
	aff_message "err" "Changement de l'utilisateur root mysql par $(aff_important "$COMPTE_ROOT")"
fi
#rm -f $FILE_SQL_UPDATE_USER_ROOT
# LOCAL : Redémarrer le service
exec_service_restart "$VAR_SERVICE_MARIADB"
