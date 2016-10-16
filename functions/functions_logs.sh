##################################################
# FUNCTIONS LOGS
##################################################
# Les fonctions sont préfixées par logs_[nom-fonction]

# FONCTION
#       logs
# BUT
# 	Journaliser l'execution du script    
# UTILISATION
#	logs
logs () {
	touch $LOG_OUT_FILE
        LOG_FILE=$LOG_OUT_FILE
}
