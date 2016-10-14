#!/bin/bash
#
# Script : config-nginx.sh
#
# Version : 1.0

#
PATH_DEBIAN8POSTINSTALL=$1
LOG_FILE=$2

# Importation des variables
. $PATH_DEBIAN8POSTINSTALL/var/debian8postinstall
. $PATH_DEBIAN8POSTINSTALL/var/nginx
# Importation des fonctions
. $PATH_DEBIAN8POSTINSTALL/functions/colors.sh
. $PATH_DEBIAN8POSTINSTALL/functions/generals.sh

# PROGRAMME

function_title "Configuration de NGINX"
# Création du dossier ~/.vim/syntax/
function_new_rep "$PATH_NGINX_VIM_SYNTAX"
# Copie du fichier $PATH_CONFS_NGINX/filetype.vim dans le dossier ~/.vim/filetype.vim
function_copy_file "$NGINX_SRC_FILETYPE_VIM" "$NGINX_DST_FILETYPE_VIM"
# Copie du fichier $PATH_CONFS_NGINX/nginx.vim dans le dossier ~/.vim/syntax/
function_copy_file "$NGINX_SRC_VIM" "$NGINX_DST_VIM"
# Créer le répertoire /etc/nginx/sites-available
function_new_rep "$PATH_NGINX_SITES_AVAILABLE"
# Créer le répertoire /etc/nginx/sites-enabled
function_new_rep "$PATH_NGINX_SITES_ENABLED"
# Copie du fichier $PATH_CONF_NGINX/nginx.conf dans le dossier /etc/nginx/nginx.conf
function_copy_file "$NGINX_SRC_CONF" "$NGINX_DST_CONF"
# Copie du fichier $PATH_CONF_NGINX/cache.conf dans le dossier /etc/nginx/conf.d/cache.conf
function_copy_file "$NGINX_SRC_CACHE" "$NGINX_DST_CACHE"
# Copie du fichier $PATH_CONF_NGINX/proxy.conf dans le dossier /etc/nginx/conf.d/proxy.conf
function_copy_file "$NGINX_SRC_PROXY" "$NGINX_DST_PROXY"
# Copie du fichier $PATH_CONF_NGINX/static.conf dans le dossier /etc/nginx/conf.d/static.conf
function_copy_file "$NGINX_SRC_STATIC" "$NGINX_DST_STATIC"
# Copie du fichier $PATH_CONF_NGINX/ssl.conf dans le dossier /etc/nginx/conf.d/ssl.conf
function_copy_file "$NGINX_SRC_SSL" "$NGINX_DST_SSL"
# Copie du fichier de configuration vers $PATH_CONF_NGINX/error.conf vers $PATH_NGINX_CONF_D/error.conf
function_copy_file "$NGINX_SRC_ERROR" "$NGINX_DST_ERROR"
# Copie du fichier de configuration vers $PATH_CONF_NGINX/_http.conf vers $PATH_NGINX_SITES_AVAILABLE/_http.conf
function_copy_file "$NGINX_SRC_HTTP" "$NGINX_DST_HTTP"
# Copie du fichier de configuration vers $PATH_CONF_NGINX/error.conf vers $PATH_NGINX_SITES_AVAILABLE/_https.conf
function_copy_file "$NGINX_SRC_HTTPS" "$NGINX_DST_HTTPS"
# Redémarrage du service
function_service_restart "$NGINX"

