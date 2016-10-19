#!/bin/bash
#
# Script : install-mariadb-server-remote.sh
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
. $PATH_DEBIAN8POSTINSTALL/functions/functions_test.sh

# PROGRAMME
# REMOTE : WHIPTAIL MSG BOX - Nécessite que le serveur distant dispose d'un serveur SSH qui autorise la connexion du compte ROOT
whiptail --title " Avertissement !!! " --msgbox "\nL'installation du serveur MariaDB sur une machine distante nécessite qu'un serveur SSH tourne sur la machine distante et que l'utilisateur de connexion dispose des droits d'administration avec la commande SUDO sans mot de passe.\n\nUn test va être réalisé afin de vérifier que l'utilisateur dispose bien des droits d'administration." 13 81
while true
do
	# REMOTE : INPUT BOX : Adresse IP du serveur de base de données distant
	while true
	do
	        SSH_SERVER=$(whiptail --title " Adresse IP du serveur de base de données MariaDB " --inputbox "\nVeuillez renseigner l'adresse IP de la machine distante, fonctionnant sous Debian 8 Jessie, qui accueillera le serveur de base de données MariaDB\n\nAdresse IP du serveur :" 12 80 3>&1 1>&2 2>&3)
	        if [ $? -eq 1 ]; then
	                exit 1
	        fi
	        if [ ! -z $SSH_SERVER ]; then
	                if [[ $SSH_SERVER =~ $REGEX_IP_ADDRESS ]]; then
	                        break
	                else
	                        whiptail --title "Erreur !" --msgbox "\nVeuillez saisir une adresse IP !" 8 37
	                fi
	        fi
	done
	# REMOTE : INPUT BOX : Login de l'utilisateur disposant des droits d'administrations
	while true
	do
	        SSH_USER=$(whiptail --title " Utilisateur SSH disposant des droits d'administration " --inputbox "\nVeuillez saisir le login d'un utilisateur disposant des droits d'administrations :" 9 86 root 3>&1 1>&2 2>&3)
	        if [ $? -eq 1 ]; then
	                exit 1
	        fi
	        if [ ! -z $SSH_USER ]; then
	                break
        	fi
	done

	# REMOTE : PASSWORD BOX : Mot de passe de l'utilisateur disposant des droits d'administrations
        while true
        do
                SSH_PASS=$(whiptail --title " Mot de passe de l'utilisateur SSH disposant des droits d'administration " --passwordbox "\nVeuillez saisir le mot de passe de l'utilisateur \"$SSH_USER\" :" 9 80 3>&1 1>&2 2>&3)
                if [ $? -eq 1 ];then
                        exit 1
                fi
                if [ ! -z "$SSH_PASS" ]; then
                        break
                else
                        whiptail --title "Erreur !" --msgbox "\nVeuillez saisir un mot de passe !" 8 37
                fi
        done
        # REMOTE : TEST : Connexion SSH & droits admin
	test_ssh "$SSH_USER" "$SSH_PASS" "$SSH_SERVER"
	if [ $? -eq 0 ]; then
                whiptail --title " Réussite du test " --msgbox "\nL'utilisateur dispose bien des droits d'administration." 10 45
                break
        else
                whiptail --title "Erreur !" --msgbox "Une erreur est survenue !\n\n- Vérifier que l'utilisateur \"$SSH_USER\" est autorisé à se connecter en SSH au serveur\n- Vérifier que l'utilisateur \"$SSH_USER\" dispose bien des droits d'administrations\n- Si ce n'est pas le cas, autoriser le avec les commandes suivantes :\n\nchmod +w /etc/sudoers\necho -e \"test\\tALL=NOPASSWD:\\tALL\" >> /etc/sudoers\nchmod -w /etc/sudoers\n\nVeuillez recommencer !" 16 85
        fi
done

# REMOTE : Lancer script $SCRIPT_INSTALL_MARIADB_SERVER_REMOTE
#exec_ssh_script "$SSH_USER" "$SSH_PASS" "$SSH_SERVER" "$SCRIPT_CONFIG_MARIADB_SERVER_REMOTE"
aff_titre "Installation de MariaDB Serveur sur le serveur $SSH_SERVER"
# REMOTE : Install Prérequis
exec_ssh_command "$SSH_USER" "$SSH_PASS" "$SSH_SERVER" "sudo aptitude -q=1 install python-software-properties software-properties-common -y"
[ $? -eq 0 ] && aff_message "ok" "Installation des prérequis" || aff_message "err" "Installation des prérequis"
# REMOTE : Import de la clé GPG
exec_ssh_command "$SSH_USER" "$SSH_PASS" "$SSH_SERVER" "sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db"
[ $? -eq 0 ] && aff_message "ok" "Importation de la clé GPG permettant de vérifier l'intégrité du dépôt" || aff_message "err" "Importation de la clé GPG permettant de vérifier l'intégrité du dépôt"
# REMOTE : Ajouter le dépôt mariadb.list - COPY SCP
exec_ssh_copy "$SSH_USER" "$SSH_PASS" "$SSH_SERVER" "$FILE_MARIADB_DEPOT_SRC" "$FILE_MARIADB_DEPOT_DST"
[ $? -eq 0 ] && aff_message "ok" "Copie du fichier $(aff_important "$FILE_MARIADB_DEPOT_SRC") vers $(aff_important "$FILE_MARIADB_DEPOT_DST")" || aff_message "err" "Copie du fichier $(aff_important "$FILE_MARIADB_DEPOT_SRC") vers $(aff_important "$FILE_MARIADB_DEPOT_DST")"
exec_ssh_command "$SSH_USER" "$SSH_PASS" "$SSH_SERVER" "sudo chown root:root $FILE_MARIADB_DEPOT_DST"
[ $? -eq 0 ] && aff_message "ok" "Changement du propriétaire du fichier $(aff_important "$FILE_MARIADB_DEPOT_DST")" || aff_message "err" "Changement du propriétaire du fichier $(aff_important "$FILE_MARIADB_DEPOT_DST")"
# REMOTE : Mise à jour des paquets
exec_ssh_command "$SSH_USER" "$SSH_PASS" "$SSH_SERVER" "sudo aptitude -q=1 update -y"
[ $? -eq 0 ] && aff_message "ok" "Mise à jour des paquets" || aff_message "err" "Mise à jour des paquets"
# REMOTE : Mot de passe root
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
exec_ssh_command "$SSH_USER" "$SSH_PASS" "$SSH_SERVER" "sudo debconf-set-selections <<< \"maria-db-10.1 mysql-server/root_password password $PASSWORD1\""
exec_ssh_command "$SSH_USER" "$SSH_PASS" "$SSH_SERVER" "sudo debconf-set-selections <<< \"maria-db-10.1 mysql-server/root_password_again password $PASSWORD2\""
[ $? -eq 0 ] && aff_message "ok" "Configuration du mot de passe MYSQL pour l'utilisateur root" || aff_message "err" "Configuration du mot de passe MYSQL pour l'utilisateur root"
# REMOTE : Installer mariadb-server 
exec_ssh_command "$SSH_USER" "$SSH_PASS" "$SSH_SERVER" "sudo aptitude -q=2 install mariadb-server -y"
[ $? -eq 0 ] && aff_message "ok" "Installation du paquet $(aff_important "$VAR_APT_MARIADB_SERVER")" || aff_message "err" Installation du paquet $(aff_important "$VAR_APT_MARIADB_SERVER")""
# REMOTE : Installer mariadb-client
exec_ssh_command "$SSH_USER" "$SSH_PASS" "$SSH_SERVER" "sudo aptitude -q=1 install mariadb-client -y"
[ $? -eq 0 ] && aff_message "ok" "Installation du paquet $(aff_important "$VAR_APT_MARIADB_CLIENT")" || aff_message "err" "Installation du paquet $(aff_important "$VAR_APT_MARIADB_CLIENT")"
# REMOTE : Copie du fichier features/mariadb/confs/debian-start dans /etc/mysql/
#exec_ssh_command "$SSH_USER" "$SSH_PASS" "$SSH_SERVER" ""
# REMOTE : Copie du fichier features/mariadb/confs/mysql dans /etc/init.d/
#exec_ssh_command "$SSH_USER" "$SSH_PASS" "$SSH_SERVER" ""
# REMOTE : Redémarrer le service
exec_ssh_command "$SSH_USER" "$SSH_PASS" "$SSH_SERVER" "sudo service mysql restart"
[ $? -eq 0 ] && aff_message "ok" "Redémarrage du service mysql" || aff_message "err" "Redémarrage du service mysql"
# REMOTE : Lancer mysql_secure_installation
exec_ssh_command "$SSH_USER" "$SSH_PASS" "$SSH_SERVER" "sudo aptitude -q=1 install expect -y"
[ $? -eq 0 ] && aff_message "ok" "Installation du paquet $(aff_important "expect")" || aff_message "err" "Installation du paquet $(aff_important "expect")"
exec_ssh_command "$SSH_USER" "$SSH_PASS" "$SSH_SERVER" "sudo expect -c \"
set timeout 3
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$PASSWORD1\r\"
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
expect eof\""
[ $? -eq 0 ] && aff_message "ok" "Sécurisation de l'installation du serveur MariaDB" || aff_message "err" "Sécurisation de l'installation du serveur MariaDB"
exec_ssh_command "$SSH_USER" "$SSH_PASS" "$SSH_SERVER" "sudo aptitude purge expect -y"
[ $? -eq 0 ] && aff_message "ok" "Suppression du paquet $(aff_important "expect")" || aff_message "err" "Suppression du paquet $(aff_important "expect")"
# REMOTE : Modifier port d'écoute
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
exec_ssh_command "$SSH_USER" "$SSH_PASS" "$SSH_SERVER" "sed -i -e \"s/$VAR_SQL_MARIADB_PORT/$PORT_SQL/g\" $FILE_MARIADB_MY_CNF"
if [ $? -eq 0 ]; then
        aff_message "ok" "Modification du port d'écoute Mysql en $(aff_important "$PORT_SQL")"
else
        aff_message "err" "Modification du port d'écoute Mysql en $(aff_important "$PORT_SQL")"
fi
# REMOTE : Modifier l'adresse d'écoute
exec_ssh_command "$SSH_USER" "$SSH_PASS" "$SSH_SERVER" "sed -i -e \"s/$VAR_SQL_MARIADB_BINDADDRESS/bind-address = $SSH_SERVER/\" $FILE_MARIADB_MY_CNF"
if [ $? -eq 0 ]; then
        aff_message "ok" "Modification de l'adresse d'écoute du serveur Mysql"
else
        aff_message "err" "Modification de l'adresse d'écoute du serveur Mysql"
fi

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
exec_ssh_command "$SSH_USER" "$SSH_PASS" "$SSH_SERVER" "sudo mysql -u root -p$PASSWORD1 -e \"RENAME USER 'root'@'127.0.0.1' TO '$COMPTE_ROOT'@'127.0.0.1';\""
exec_ssh_command "$SSH_USER" "$SSH_PASS" "$SSH_SERVER" "sudo mysql -u root -p$PASSWORD1 -e \"RENAME USER 'root'@'::1' TO '$COMPTE_ROOT'@'::1';\""
exec_ssh_command "$SSH_USER" "$SSH_PASS" "$SSH_SERVER" "sudo mysql -u root -p$PASSWORD1 -e \"RENAME USER 'root'@'localhost' TO '$COMPTE_ROOT'@'localhost';\""
[ $? -eq 0 ] && aff_message "ok" "Modification du nom d'utilisateur du compte root par $(aff_important "$COMPTE_ROOT")" || aff_message "err" "Modification du nom d'utilisateur du compte root par $(aff_important "$COMPTE_ROOT")"
# REMOTE : Autoriser les connexions distantes depuis le serveur Web
exec_ssh_command "$SSH_USER" "$SSH_PASS" "$SSH_SERVER" "sudo mysql -u root -p$PASSWORD1 -e \"GRANT ALL PRIVILEGES ON *.* TO '$COMPTE_ROOT'@'$WEB_SERVER' IDENTIFIED BY '$PASSWORD1' WITH GRANT OPTION;\""
[ $? -eq 0 ] && aff_message "ok" "Autorisation de connexion de l'utilisateur MYSQL $(aff_important "$COMPTE_ROOT") depuis le serveur Web" || aff_message "err" "Autorisation de connexion de l'utilisateur MYSQL $(aff_important "$COMPTE_ROOT") depuis le serveur Web"
exec_ssh_command "$SSH_USER" "$SSH_PASS" "$SSH_SERVER" "sudo mysql -u root -p$PASSWORD1 -e \"FLUSH PRIVILEGES;\""
# REMOTE : Redémarrer le service
exec_ssh_command "$SSH_USER" "$SSH_PASS" "$SSH_SERVER" "sudo service mysql restart"
[ $? -eq 0 ] && aff_message "ok" "Redémarrage du service $(aff_important "mysql")" || aff_message "err" "$(aff_important "mysql")"
