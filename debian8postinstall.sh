#!/bin/bash
#
# Nom : debian8postinstall.sh
# Version : 1.0
#

# Importation des variables
. variables
. functions/functions_colors.sh
. functions/functions_affichage.sh
. functions/functions_execution.sh
. functions/functions_logs.sh

# Prérequis
clear
logs
aff_titre "Installation des prérequis"
exec_apt_install_uniq "$APT_WHIPTAIL"
# Programme
RESULTATS=$(whiptail --title "Debian 8 Jessie Post-installation" --checklist \
"\nCe script post-installation permet d'installer et de configurer différents paquets. Sélectionner ceux que vous souhaitez installer dans la liste ci-dessous.\n\nPar défaut, tous les paquets sont cochés.\n\nQue souhaitez vous faire ?" 23 71 7 \
"Nginx" "Installer et configurer NGINX" ON \
"Php7-fpm" "Installer et configurer PHP7-FPM" ON \
"Mariadb-server" "Installer et configurer Mariadb-Server" ON \
"Mariadb-client" "Installer et configurer Mariadb-Client" ON \
"Lets-encrypt" "Installer et configurer Let's Encrypt" ON \
"Varnish" "Installer et configurer Varnish 4.0 Cache" ON \
"Wordpress" "Installer et configurer Wordpress" OFF 3>&1 1>&2 2>&3)

for RESULTAT in $(echo $RESULTATS | sed 's/\"//g' | tr ' ' '\n');
do
	case "$RESULTAT" in
		"Nginx") 
			#bash $SCRIPT_INSTALL_NGINX $PATH_CURRENT $LOG_FILE
			#bash $SCRIPT_CONFIG_NGINX $PATH_CURRENT $LOG_FILE
		;;
		"Php7-fpm") 
                        #bash $SCRIPT_INSTALL_PHP7FPM $PATH_CURRENT $LOG_FILE
                        #bash $SCRIPT_CONFIG_PHP7FPM $PATH_CURRENT $LOG_FILE
		;;
		"Mariadb-server")
                        bash $SCRIPT_INSTALL_MARIADB_SERVER $PATH_CURRENT $LOG_FILE
                ;;
		"Mariadb-client") 
                        #bash $SCRIPT_INSTALL_MARIADB_CLIENT $PATH_CURRENT $LOG_FILE
                        #bash $SCRIPT_CONFIG_MARIADB_CLIENT $PATH_CURRENT $LOG_FILE
		;;
                "Lets-encrypt") 
                        #bash $SCRIPT_INSTALL_LETSENCRYPT $PATH_CURRENT $LOG_FILE
                        #bash $SCRIPT_CONFIG_LETSENCRYPT $PATH_CURRENT $LOG_FILE
		;;
                "Varnish") 
                        #bash $SCRIPT_INSTALL_VARNISH $PATH_CURRENT $LOG_FILE
                        #bash $SCRIPT_CONFIG_VARNISH $PATH_CURRENT $LOG_FILE
                        #bash $SCRIPT_CONFIG_VARNISH_FIREWALL $PATH_CURRENT $LOG_FILE
                        #bash $SCRIPT_CONFIG_VARNISH_DDOS $PATH_CURRENT $LOG_FILE
		;;
                "Wordpress") 
                        #bash $SCRIPT_INSTALL_WORDPRESS $PATH_CURRENT $LOG_FILE
                        #bash $SCRIPT_CONFIG_WORDPRESS $PATH_CURRENT $LOG_FILE
		;;
	esac
done
