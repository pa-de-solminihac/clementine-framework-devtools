#!/bin/bash

usage() {

    echo "Usage : `basename $0` <module>"

    cat <<EOF
Cree une arborescence de base pour un module

    <module> est le nom du module

EOF
    exit 0
}

#help
if [[ "$#" != 1 ]]
then
    usage
fi

#parameters
MODULE="$(echo "$1" | awk '{print tolower($0)}')"

#security check: create, but dont overwrite
CREATED="$(mkdir $MODULE && echo 'OK')"
if [[ "$CREATED" != "OK" ]]
then
    echo "Directory $MODULE already exists ! Dying and not overwriting..."
    exit
fi

# create basic config files
mkdir -p $MODULE/etc
echo "[module_$MODULE]
" > $MODULE/etc/config.ini
echo "version=1.0
weight=0.5
; dependances de la version 1.* du module $MODULE
[depends_1]
" > $MODULE/etc/module.ini

# create basic directory structure
mkdir -p $MODULE/lib
mkdir -p $MODULE/ctrl
mkdir -p $MODULE/model
mkdir -p $MODULE/helper
mkdir -p $MODULE/view/$MODULE

# skin directory will be accessed from HTTP
mkdir -p $MODULE/skin/{js,css,images}
echo 'order allow,deny' > $MODULE/skin/.htaccess
echo 'allow from all' >> $MODULE/skin/.htaccess

