##################################################
# FICHIER DE CONFIGURATION DES POLICES & COULEURS
##################################################

##################################################
# ATTRIBUTES
##################################################
FONT_START="\e["
FONT_END="m"

##################################################
# FOREGROUND
##################################################
FG_DEFAULT="39"
FG_BLACK="30"
FG_RED="31"
FG_GREEN="32"
FG_YELLOW="33"
FG_BLUE="34"
FG_MAGENTA="35"
FG_CYAN="36"
FG_LIGHT_GRAY="37"
FG_DARK_GRAY="90"
FG_LIGHT_RED="91"
FG_LIGHT_GREEN="92"
FG_LIGHT_YELLOW="93"
FG_LIGHT_BLUE="94"
FG_LIGHT_MAGENTA="95"
FG_LIGHT_CYAN="96"
FG_WHITE="97"

####################################################
# BACKGROUND
####################################################
BG_DEFAULT="49"
BG_BLACK="40"
BG_RED="41"
BG_GREEN="42"
BG_YELLOW="43"
BG_BLUE="44"
BG_MAGENTA="45"
BG_CYAN="46"
BG_LIGHT_GRAY="47"
BG_DARK_GRAY="100"
BG_LIGHT_RED="101"
BG_LIGHT_GREEN="102"
BG_LIGHT_YELLOW="103"
BG_LIGHT_BLUE="104"
BG_LIGHT_MAGENTA="105"
BG_LIGHT_CYAN="106"
BG_WHITE="107"

###################################################
# POLICES
###################################################
FT_DEFAULT="0"
FT_BOLD="1"
FT_DIM="2"
FT_UNDERLINE="4"
FT_BLINK="5"
FT_REVERSE="7"
FT_HIDDEN="8"

FT_RESET_ALL="0"
FT_RESET_BOLD="21"
FT_RESET_DIM="22"
FT_RESET_UNDERLINE="24"
FT_RESET_BLINK="25"
FT_RESET_REVERSE="27"
FT_RESET_HIDDEN="28"

###################################################
# FONCTIONS
###################################################

# FUNCTION DEFAULT
# arg 1 : FOREGROUND
# arg 2 : BACKGROUND
ft_default () {
        if [ -z $2 ]; then
                echo $FONT_START$FT_DEFAULT";"$1$FONT_END
        else
                echo $FONT_START$FT_DEFAULT";"$1";"$2$FONT_END
        fi
}

# FUNCTION BOLD 
# arg 1 : FOREGROUND 
# arg 2 : BACKGROUND 
ft_bold () {
	if [ -z $2 ]; then
		echo $FONT_START$FT_BOLD";"$1$FONT_END
	else
		echo $FONT_START$FT_BOLD";"$1";"$2$FONT_END
	fi
}

# FUNCTION DIM
# arg 1 : FOREGROUND
# arg 2 : BACKGROUND
ft_dim () {
	if [ -z $2 ]; then
                echo $FONT_START$FT_DIM";"$1$FONT_END
	else
		echo $FONT_START$FT_DIM";"$1";"$2$FONT_END
	fi
}

# FUNCTION UNDERLINE
# arg 1 : FOREGROUND
# arg 2 : BACKGROUND
ft_underline () {
        if [ -z $2 ]; then
                echo $FONT_START$FT_UNDERLINE";"$1$FONT_END
	else
                echo $FONT_START$FT_UNDERLINE";"$1";"$2$FONT_END	
	fi
}

# FUNCTION BLINK
# arg 1 : FOREGROUND
# arg 2 : BACKGROUND
ft_blink () {
        if [ -z $2 ]; then
                echo $FONT_START$FT_BLINK";"$1$FONT_END
        else
                echo $FONT_START$FT_BLINK";"$1";"$2$FONT_END
        fi
}

# FUNCTION REVERSE
# arg 1 : FOREGROUND
# arg 2 : BACKGROUND
ft_reverse () {
        if [ -z $2 ]; then
                echo $FONT_START$FT_REVERSE";"$1$FONT_END
        else
                echo $FONT_START$FT_REVERSE";"$1";"$2$FONT_END
        fi
}

# FUNCTION HIDDEN
# arg 1 : FOREGROUND
# arg 2 : BACKGROUND
ft_hidden () {
        if [ -z $2 ]; then
                echo $FONT_START$FT_HIDDEN";"$1$FONT_END
        else
                echo $FONT_START$FT_HIDDEN";"$1";"$2$FONT_END
        fi
}

# FUNCTION CLEAR
ft_clear () {
	echo $FONT_START$FT_RESET_ALL$FONT_END
}

# FUNCTION BOLD CLEAR
# arg 1 : FOREGROUND
# arg 2 : BACKGROUND
ft_bold_clear () {
        echo $FONT_START$FT_RESET_BOLD$FONT_END
}

# FUNCTION DIM CLEAR
# arg 1 : FOREGROUND
# arg 2 : BACKGROUND
ft_dim_clear () {
        echo $FONT_START$FT_RESET_DIM$FONT_END
}

# FUNCTION UNDERLINE CLEAR
# arg 1 : FOREGROUND
# arg 2 : BACKGROUND
ft_underline_clear () {
        echo $FONT_START$FT_RESET_UNDERLINE$FONT_END
}

# FUNCTION BLINK CLEAR
# arg 1 : FOREGROUND
# arg 2 : BACKGROUND
ft_blink_clear () {
        echo $FONT_START$FT_RESET_BLINK$FONT_END
}

# FUNCTION REVERSE CLEAR
# arg 1 : FOREGROUND
# arg 2 : BACKGROUND
ft_reverse_clear () {
        echo $FONT_START$FT_RESET_REVERSE$FONT_END
}

# FUNCTION HIDDEN CLEAR
# arg 1 : FOREGROUND
# arg 2 : BACKGROUND
ft_hidden_clear () {
        echo $FONT_START$FT_RESET_HIDDEN$FONT_END
}
