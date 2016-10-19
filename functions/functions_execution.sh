##################################################
# FUNCTIONS EXECUTION
# Les fonctions décrites ici sont des fonctions d'exécutions
##################################################
# Les fonctions sont préfixées par fct_exec_@NOM-FONCTION@


# FONCTION
#       exec_echo $1
# PARAMETRES
#       $1 : Nom de la commande
# BUT
#       Afficher sur la sortie STDOUT et dans le fichier de log
# UTILISATION
#       exec_echo "$MESSAGE"
exec_echo () {
        MESSAGE=$1
        echo -e "$MESSAGE" | tee -a $LOG_FILE
} 

# FONCTION
#       exec_command $1
# PARAMETRES
#       $1 : Nom de la commande à exécuter
# BUT
#       Exécuter la commande et l'inscrire dans le fichier de log
# UTILISATION
#       exec_command "$COMMANDE"
exec_command () {
	COMMANDE=$1
	$COMMANDE >> $LOG_FILE 2>&1
	[ $? -eq 0 ] && CODE_RETOUR=0 || CODE_RETOUR=1
	return $CODE_RETOUR
}

# FONCTION
#       exec_command_debug $1
# PARAMETRES
#       $1 : Commande à exécuter et à débugguer
# BUT
#       Exécuter la commande et débugguer
# UTILISATION
#       exec_command_debug "$COMMANDE"
exec_command_debug () {
        COMMANDE=$1
	set -x
        $COMMANDE
	[ $? -eq 0 ] && CODE_RETOUR=0 || CODE_RETOUR=1
        return $CODE_RETOUR
}

# FONCTION
#	exec_find_command $1
# PARAMETRES
#       $1 : Nom de la commande
# BUT
#       Rechercher si la commande est disponible sur le système
# UTILISATION
#	exec_find_command "$COMMANDE"
exec_find_command () {
        COMMAND=$1
        command -v $COMMAND > /dev/null 2>&1
}

# FONCTION
#	exec_root       
# PARAMETRES
#	       
# BUT
#      Vérifier si l'utilisateur d'exécution est root et afficher un message en cas d'erreur
# UTILISATION
#     exec_root
exec_root () {
        if [[ $EUID -ne 0 ]]; then
		aff_message "err" "Ce script doit être exécuté en `aff_important "root"` !"
		exit 1
	fi
}

##################################################################################################################
# APT-GET
##################################################################################################################

# FONCTION
#	exec_apt_add_depot $1
# PARAMETRES
#   	$1 : Nom du dépôt à ajouter
# BUT
#  	Ajouter un dépôt au système et afficher un message de retour de l'exécution de la commande
# UTILISATION
# 	exec_apt_add_depot "$DEPOT"
exec_apt_add_depot () {
	FILE_DEPOT=$1
	DEPOT=$(basename $FILE_DEPOT)
        exec_command "cp -p $FILE_DEPOT $PATH_APT_SOURCES_LIST_D/"
        if [ $? -eq 0 ]; then
		aff_message "ok" "Ajout du dépôt $(aff_important "$DEPOT")"
		exec_apt_update
	else
		aff_message "err" "Ajout du dépôt $(aff_important "$DEPOT")"
		exit 1
	fi
}

# FONCTION
#	exec_apt_update
# PARAMETRES
#
# BUT
#	Mettre à jour la liste des paquets et afficher un message de retour de l'exécution de la commande
# UTILISATION
#	exec_apt_update
exec_apt_update () {
        exec_command "aptitude -q=1 update -y"
        if [ $? -eq 0 ]; then
		aff_message "ok" "Mise à jour de la liste des paquets"
	else
		aff_message "err" "Mise à jour de la liste des paquets"
	fi
}

# FONCTION
#	exec_apt_upgrade
# BUT
#	Mettre à jour tous les paquets du système et afficher un message de retour de l'exécution de la commande
# UTILISATION
#	exec_apt_upgrade
exec_apt_upgrade () {
        exec_command "aptitude -q=1 upgrade -y"
        if [ $? -eq 0 ]; then
		aff_message "ok" "Mise à jour de tous les paquets du système"
	else
		aff_message "err" "Mise à jour de tous les paquets du système"
	fi
}

# FONCTION
#	exec_apt_install_uniq $1
# PARAMETRES
#	$1 : Nom du paquet à installer
# BUT
#	Installer le paquet passé en paramètre et afficher un message de retour de l'exécution de la commande
# UTILISATION
#	exec_apt_install_uniq "$PAQUET"
exec_apt_install_uniq () {
        PAQUET=$1
        exec_command "aptitude -q=1 install $PAQUET -y"
        if [ $? -eq 0 ]; then
		aff_message "ok" "Installation du paquet `aff_important "$PAQUET"`"
	else
		aff_message "err" "Installation du paquet `aff_important "$PAQUET"`"
	fi
}

# FONCTION
#       exec_apt_install_mariadb $1
# PARAMETRES
#       $1 : Nom du paquet à installer
# BUT
#       Installer le paquet passé en paramètre et afficher un message de retour de l'exécution de la commande
# UTILISATION
#       exec_apt_install_mariadb "$PAQUET"
exec_apt_install_mariadb () {
        PAQUET=$1
        exec_command "aptitude -q=2 install $PAQUET -y"
        if [ $? -eq 0 ]; then
                aff_message "ok" "Installation du paquet `aff_important "$PAQUET"`"
        else
                aff_message "err" "Installation du paquet `aff_important "$PAQUET"`"
        fi
}

# FONCTION
#	exec_apt_multi_install $1 $2
# PARAMETRES
#	$1 : Nom du service
#	$2 : Noms des paquets à installer
# BUT
#	Installer les paquets passés en paramètre et afficher un message de retour de l'exécution de la commande
# UTILISATION
#	exec_apt_install_multi "$SERVICE" "$PAQUETS"
exec_apt_install_multi () {
	SERVICE=$1
	PAQUETS=$2
        exec_command "aptitude -q=1 install $PAQUETS -y"
        if [ $? -eq 0 ]; then
		aff_message "ok" "Installation des paquets pour $(aff_important "$SERVICE")"
	else
		aff_message "err" "Installation des paquets pour $(aff_important "$SERVICE")"
	fi
}

# FONCTION
#       exec_apt_multi_prerequis $1
# PARAMETRES
#       $1 : Noms des paquets à installer
# BUT
#       Installer les prérequis et afficher un message de retour de l'exécution de la commande
# UTILISATION
#       exec_apt_install_prerequis "$PAQUETS"
exec_apt_install_prerequis () {
        PAQUETS=$1
        exec_command "aptitude -q=1 install $PAQUETS -y"
        if [ $? -eq 0 ]; then
                aff_message "ok" "Installation des prérequis"
        else
                aff_message "err" "Installation des prérequis"
        fi
}

# FONCTION
#	exec_apt_remove $1
# PARAMETRES
#	$1 : Nom du paquet à désinstaller
# BUT
#	Désinstaller le paquet passé en paramètre et afficher un message de retour de l'exécution de la commande
# UTILISATION
#	exec_apt_remove "$PAQUET"
exec_apt_remove () {
        PAQUET=$1
        exec_command "aptitude purge $PAQUET -y"
        if [ $? -eq 0 ]; then 
		aff_message "ok" "Désinstallation du paquet `aff_important "$PAQUET"`"
	else
		aff_message "err" "Désinstallation du paquet `aff_important "$PAQUET"`"
	fi
}

##################################################################################################################
# IMPORTATION
##################################################################################################################

# FONCTION
#       exec_import_pgp_url $1
# PARAMETRES
#       $1 : URL de la clé PGP à importer
# BUT
#       Importer la clé PGP permettant de vérifier la validité du dépôt et afficher un message de retour de l'exécution de la commande
# UTILISATION
#       exec_import_pgp_url "$URL_GPG"
exec_import_pgp_url () {
	URL_PGP=$1
	exec_command "wget -qO /tmp/key $URL_PGP"
	exec_command "apt-key add /tmp/key"
	#exec_command "wget -qO - $URL_PGP | apt-key add -"
	if [ $? -eq 0 ]; then
		aff_message "ok" "Importation de la clé PGP"
	else
		aff_message "err" "Importation de la clé PGP"
	fi
}

# FONCTION
#       exec_import_gpg_apt $1
# PARAMETRES
#       $1 : Clé GPG à importer
# BUT
#       Importer la clé GPG permettant de vérifier la validité du dépôt et afficher un message de retour de l'exécution de la commande
# UTILISATION
#       exec_import_gpg_apt "$KEY_GPG"
exec_import_gpg_apt () {
	KEY_GPG=$1
        exec_command "apt-key adv --recv-keys --keyserver $KEY_GPG"
        if [ $? -eq 0 ]; then
                aff_message "ok" "Importation de la clé GPG"
        else
                aff_message "err" "Importation de la clé GPG"
        fi
}

##################################################################################################################
# COPIE DE FICHIERS
##################################################################################################################

# FONCTION
#       exec_copy_file $1 $2
# PARAMETRES
#       $1 : Fichier source à copier
#	$2 : Fichier de destination
# BUT
#       Copier le fichier et afficher un message de retour de l'exécution de la commande
# UTILISATION
#       exec_copy_file "$SRC_FILE" "$DST_FILE"
exec_copy_file () {
        SRC_FILE=$1
        DST_FILE=$2
        exec_command "cp -fp $SRC_FILE $DST_FILE"
        if [ $? -eq 0 ]; then
		aff_message "ok" "Copie du fichier `aff_important "$SRC_FILE"` vers `aff_important "$DST_FILE"`"
	else
		aff_message "err" "Copie du fichier `aff_important "$SRC_FILE"` vers `aff_important "$DST_FILE"`"
	fi
}

##################################################################################################################
# CREATION DE REPERTOIRE
##################################################################################################################

# FONCTION
#       exec_new_rep $1
# PARAMETRES
#       $1 : Nom du dossier à créer
# BUT
#       Créer le dossier et ses dossiers parents puis afficher un message de retour de l'exécution de la commande
# UTILISATION
#       exec_new_rep "$FOLDER"
exec_new_rep () {
        FOLDER=$1
        if [ ! -d "$FOLDER" ]; then
                exec_command "mkdir --parents $FOLDER"
                aff_message "ok" "Création du répertoire `aff_important "$FOLDER"`"
        fi
}

##################################################################################################################
# REMPLACER
##################################################################################################################

# FONCTION
#       exec_sed $1 $2 $3
# PARAMETRES
#       $1 : Expression à remplacer
#	$2 : Expression de remplacement
#	$3 : Fichier à modifier
# BUT
#       Modifier une expression dans un fichier
# UTILISATION
#       exec_sed "$MOT" "$MODIFICATION" "$FICHIER"
exec_sed_uniq () {
	#set -x
	MOT=$(echo $1 | sed -e 's/[]\/\$*.^|[]/\\&/g')
	MODIFICATION=$(echo $2 | sed -e 's/[]\/\$*.^|[]/\\&/g')
	FILE=$3
	exec_command "sed -i 's/$MOT/$MODIFICATION/' $FICHIER"
	if [ $? -eq 0 ]; then
                aff_message "ok" "Remplacement de l'expression $(aff_important $1) par $(aff_important $2) dans le fichier $($FILE)"
        else
                aff_message "err" "Remplacement de l'expression $(aff_important $1) par $(aff_important $2) dans le fichier $($FILE)"
        fi
}

##################################################################################################################
# SERVICES
##################################################################################################################

# FONCTION
#	exec_service_start $1
# PARAMETRES
#	$1 : Service à démarrer
# BUT
#	Démarrer le service
# UTILISATION
#	exec_service_start "$SERVICE"
exec_service_start () {
	SERVICE=$1
	exec_command "service $SERVICE start"
	if [ $? -eq 0 ]; then
                aff_message "ok" "Le service `aff_important "$SERVICE"` a démarré"
        else
                aff_message "err" "Le service `aff_important "$SERVICE"` n'a pas pu démarrer !"
        fi
}

# FONCTION
#       exec_service_stop $1
# PARAMETRES
#       $1 : Service à arrêter
# BUT
#       Arrêter le service
# UTILISATION
#       exec_service_stop "$SERVICE"
exec_service_stop () { 
	SERVICE=$1
        exec_command "service $SERVICE stop"
        if [ $? -eq 0 ]; then
                aff_message "ok" "Le service `aff_important "$SERVICE"` s'est arrêter"
        else
                aff_message "err" "Le service `aff_important "$SERVICE"` n'a pas pu s'arrêter !"
        fi
}

# FONCTION
#       exec_service_restart $1
# PARAMETRES
#       $1 : Service à redémarrer
# BUT
#       Redémarrer le service
# UTILISATION
#       exec_service_restart "$SERVICE"
exec_service_restart () {
	SERVICE=$1
	exec_service_stop $SERVICE
	exec_service_start $SERVICE
}

##################################################################################################################
# MYSQL
##################################################################################################################

# FONCTION
#       exec_mysql $1 $2 $3
# PARAMETRES
#       $1 : Login de l'utilisateur
#	$2 : Mot de passe de l'utilisateur
# BUT
#       Exécuter les commandes SQL présentes dans le fichier SQL $FILE_SQL_UPDATE_USER_ROOT
# UTILISATION
#       exec_mysql "$MYSQL_USER" "$MYSQL_PASS"
exec_mysql () {
	MYSQL_USER=$1
	MYSQL_PASS=$2
	
	echo "RENAME USER 'root'@'127.0.0.1' TO '$MYSQL_USER'@'127.0.0.1';" > $FILE_SQL_UPDATE_USER_ROOT
	echo "RENAME USER 'root'@'::1' TO '$MYSQL_USER'@'::1';" >> $FILE_SQL_UPDATE_USER_ROOT
	echo "RENAME USER 'root'@'localhost' TO '$MYSQL_USER'@'localhost';" >> $FILE_SQL_UPDATE_USER_ROOT
	echo "FLUSH PRIVILEGES;" >> $FILE_SQL_UPDATE_USER_ROOT

	mysql -u root -p$MYSQL_PASS < $FILE_SQL_UPDATE_USER_ROOT >> $LOG_FILE 2>&1
	if [ $? -eq 0 ]; then
		aff_message "ok" "Changement de l'utilisateur $(aff_important "root") mysql par $(aff_important "$MYSQL_USER")"
	else
		aff_message "err" "Changement de l'utilisateur $(aff_important "root") mysql par $(aff_important "$MYSQL_USER")"
	fi

	rm -f $FILE_SQL_UPDATE_USER_ROOT
}

##################################################################################################################
# CHARGEMENT
##################################################################################################################

# FONCTION
#       exec_load $1 $2 
# PARAMETRES
#       $1 : 
#       $2 : 
# BUT
#       
# UTILISATION
#       exec_load
#exec_load () {}
