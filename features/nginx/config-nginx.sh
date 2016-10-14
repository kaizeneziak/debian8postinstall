#!/bin/bash
#
# Script : config-nginx.sh
#
# Version : 1.0

#
PATH_DEBIAN8POSTINSTALL=$1
LOG_FILE=$2

# Importation des variables
. $PATH_DEBIAN8POSTINSTALL/variables # Importation des variables de haut niveau
. $PATH_FEATURE_NGINX/variables # Importation des variables propres à NGINX

# Importation des fonctions
. $PATH_DEBIAN8POSTINSTALL/functions/functions_colors.sh
. $PATH_DEBIAN8POSTINSTALL/functions/functions_affichage.sh
. $PATH_DEBIAN8POSTINSTALL/functions/functions_execution.sh

# PROGRAMME

aff_titre "Configuration de NGINX"
# Création du dossier ~/.vim/syntax/
exec_new_rep "$PATH_NGINX_VIM_SYNTAX"
# Copie du fichier $PATH_CONFS_NGINX/filetype.vim dans le dossier ~/.vim/filetype.vim
exec_copy_file "$NGINX_SRC_FILETYPE_VIM" "$NGINX_DST_FILETYPE_VIM"
# Copie du fichier $PATH_CONFS_NGINX/nginx.vim dans le dossier ~/.vim/syntax/
exec_copy_file "$NGINX_SRC_VIM" "$NGINX_DST_VIM"
# Créer le répertoire /etc/nginx/sites-available
exec_new_rep "$PATH_NGINX_SITES_AVAILABLE"
# Créer le répertoire /etc/nginx/sites-enabled
exec_new_rep "$PATH_NGINX_SITES_ENABLED"
# Copie du fichier $PATH_CONF_NGINX/nginx.conf dans le dossier /etc/nginx/nginx.conf
exec_copy_file "$NGINX_SRC_CONF" "$NGINX_DST_CONF"
# Copie du fichier $PATH_CONF_NGINX/cache.conf dans le dossier /etc/nginx/conf.d/cache.conf
exec_copy_file "$NGINX_SRC_CACHE" "$NGINX_DST_CACHE"
# Copie du fichier $PATH_CONF_NGINX/proxy.conf dans le dossier /etc/nginx/conf.d/proxy.conf
exec_copy_file "$NGINX_SRC_PROXY" "$NGINX_DST_PROXY"
# Copie du fichier $PATH_CONF_NGINX/static.conf dans le dossier /etc/nginx/conf.d/static.conf
exec_copy_file "$NGINX_SRC_STATIC" "$NGINX_DST_STATIC"
# Copie du fichier $PATH_CONF_NGINX/ssl.conf dans le dossier /etc/nginx/conf.d/ssl.conf
exec_copy_file "$NGINX_SRC_SSL" "$NGINX_DST_SSL"
# Copie du fichier de configuration vers $PATH_CONF_NGINX/error.conf vers $PATH_NGINX_CONF_D/error.conf
exec_copy_file "$NGINX_SRC_ERROR" "$NGINX_DST_ERROR"
# Copie du fichier de configuration vers $PATH_CONF_NGINX/_http.conf vers $PATH_NGINX_SITES_AVAILABLE/_http.conf
exec_copy_file "$NGINX_SRC_HTTP" "$NGINX_DST_HTTP"
# Copie du fichier de configuration vers $PATH_CONF_NGINX/error.conf vers $PATH_NGINX_SITES_AVAILABLE/_https.conf
exec_copy_file "$NGINX_SRC_HTTPS" "$NGINX_DST_HTTPS"
# Redémarrage du service
exec_service_restart "$NGINX"

