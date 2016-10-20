##################################################
# FUNCTIONS 
##################################################
# Les fonctions sont préfixées par [type-de-fonction]_[nom-fonction]

# FONCTION
#	test_ssh $1 $2 $3       
# PARAMETRES
#      	$1 : Login de l'utilisateur SSH
#	$2 : Mot de passe de l'utilisateur
#	$3 : Adresse IP du serveur
# BUT
#     Tester une connexion SSH au serveur $3 avec le compte utilisateur $1
# UTILISATION
#	test_ssh "$SSH_USER" "$SSH_PASS" "$SSH_SERVER"
test_ssh () {
	SSH_USER=$1
	SSH_PASS=$2
	SSH_SERVER=$3
	
	exec_ssh_command "$SSH_USER" "$SSH_PASS" "$SSH_SERVER" "sudo -v"
	if [ $? -eq 0 ]; then
		#whiptail --title " Réussite du test " --msgbox "\nL'utilisateur dispose bien des droits d'administration." 8 37
		RETOUR=0
	else
		RETOUR=1
	fi
	return $RETOUR
}

# FONCTION
#       test_mariadb $1 $2 $3 $4
# PARAMETRES
#       $1 : Login de l'utilisateur SSH
#       $2 : Mot de passe de l'utilisateur
#       $3 : Adresse IP du serveur Mariadb
#	$4 : Port d'écoute du serveur Mariadb
# BUT
#     	Tester une connexion au serveur MariaDB
# UTILISATION
#       test_ssh "$MARIADB_USER" "$MARIADB_PASS" "$MARIADB_SERVER" "$MARIADB_PORT"
test_mariadb () {
        MARIADB_USER=$1
        MARIADB_PASS=$2
        MARIADB_SERVER=$3
	MARIADB_PORT=$4

        exec_command "mysql -u $MARIADB_USER -h $MARIADB_SERVER -P $MARIADB_PORT -p'$MARIADB_PASS' -e \"SHOW DATABASES;\""
        if [ $? -eq 0 ]; then
                RETOUR=0
        else
                RETOUR=1
        fi
        return $RETOUR
}

