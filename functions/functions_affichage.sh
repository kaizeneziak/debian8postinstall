##################################################
# FUNCTIONS AFFICHAGE
##################################################
# Les fonctions sont préfixées par aff_[nom de la fonction]

# FONCTION
#	aff_message() $1 $2
# PARAMETRES
#	$1 : Type du message à afficher
#	$2 : Texte du message à afficher
# BUT
#	Affiche un message à l'utilisateur
# UTILISATION
#	aff_message "ok" "message" - Affiche un message de confirmation 
#	aff_message "info" "message" - Affiche un message d'information 
#       aff_message "war" "message" - Affiche un message d'avertissement
#       aff_message "err" "message" - Affiche un message d'erreur
#       aff_message "read" "message" - Affiche un message ?
#       aff_message "debug" "message" - Affiche un message de debug
#       aff_message "encours" "message" - Affiche un message d'exécution
aff_message () {
        TYPE_MESSAGE=$1
        MESSAGE=$2

        case "$TYPE_MESSAGE" in
                "ok") exec_echo "[ `ft_default $FG_LIGHT_GREEN $BG_DEFAULT`Ok`ft_clear` ] : $MESSAGE" ;;
                "info") exec_echo "[ `ft_default $FG_LIGHT_CYAN $BG_DEFAULT`Info`ft_clear` ] : $MESSAGE" ;;
                "war") exec_echo "[ `ft_default $FG_YELLOW $BG_DEFAULT`Warning`ft_clear` ] : $MESSAGE" ;;
                "err") exec_echo "[ `ft_default $FG_RED $BG_DEFAULT`Erreur`ft_clear` ] : $MESSAGE" ;;
                "read") exec_echo "`ft_default $FG_YELLOW $BG_DEFAULT`$MESSAGE`ft_clear`" ;;
                "debug") exec_echo "`ft_default $FG_YELLOW $BG_DEFAULT`#\n# DEBUG : $MESSAGE `ft_default $FG_YELLOW $BG_DEFAULT`\n#`ft_clear`" ;;
                "encours") exec_echo "[ `ft_blink $FG_YELLOW $BG_DEFAULT`En cours`ft_clear` ] : $MESSAGE" ;;
        esac
}

# FONCTION
#       aff_important() $1
# PARAMETRES
#       $1 : Message à mettre en valeur
# BUT
#       Mettre en valeur un message
# UTILISATION
#       aff_important "$IMPORTANT" - Met en valeur le message "$IMPORTANT"
aff_important () {
        IMPORTANT=$1
        exec_echo "`ft_bold $FG_LIGHT_BLUE $BG_DEFAULT`$IMPORTANT`ft_clear`"
}

# FONCTION
#       aff_titre() $1
# PARAMETRES
#       $1 : Message à afficher en titre
# BUT
#       Affiche un titre à l'utilisateur
# UTILISATION
#       aff_titre "$TITRE" - Affiche le titre "$TITRE"
aff_titre () {
        TITRE=$1
        exec_echo "\n`ft_default $FG_YELLOW $BG_DEFAULT`==============================================================="
        exec_echo "# $TITRE"
        exec_echo "===============================================================`ft_clear`"
}

