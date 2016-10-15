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
exec_copy_file "$FILE_MARIADB_DEBIAN_START_SRC" "$FILE_MARIADB_DEBIAN_START_DST"
# LOCAL : Copie du fichier features/mariadb/confs/mysql dans /etc/init.d/
exec_copy_file "$FILE_MARIADB_DEBIAN_INIT_SRC" "$FILE_MARIADB_DEBIAN_INIT_DST"
# LOCAL : Redémarrer le service
exec_service_restart "$VAR_SERVICE_MARIADB"

# LOCAL : Lancer mysql_secure_installation
bash $SCRIPT_CONFIG_MARIADB_SECURE_INSTALL $PATH_DEBIAN8POSTINSTALL $LOG_FILE
# LOCAL : Modifier port d'écoute

# LOCAL : Modifier le compte root

