#!/usr/bin/env bash
GREEN=`echo -e '\033[0m\033[1;32m'`
NORMAL=`echo -e '\033[0m'`
MODULES="$(cat modules.list)"
for MODULE in ${MODULES[@]}
do
    mkdir -p ../modules/$MODULE/trunk
    mkdir -p ../modules/$MODULE/repository/scripts

    if [ ! -d "../modules/$MODULE/trunk/.git" ];
    then
        echo "${GREEN}Importing ${MODULE}${NORMAL}"
        cd ../modules/$MODULE/trunk/
        git clone git@github.com:pa-de-solminihac/clementine-framework-module-${MODULE}.git . || echo "You should create the repository pa-de-solminihac/clementine-framework-module-${MODULE}"
        cd -
    fi

    if [ ! -d "../modules/$MODULE/repository/scripts/.git" ];
    then
        echo "${GREEN}Importing ${MODULE} scripts ${NORMAL}"
        cd ../modules/$MODULE/repository/scripts
        #git init
        #git add depends.ini versions
        #git commit -m "$MODULE 1.0 scripts"
        #git remote add origin git@github.com:pa-de-solminihac/clementine-framework-module-${MODULE}-scripts.git
        git clone git@github.com:pa-de-solminihac/clementine-framework-module-${MODULE}-scripts.git . || echo "You should create the repository git@github.com:pa-de-solminihac/clementine-framework-module-${MODULE}-scripts.git"
        cd -
    fi

    # on remplit avec les éléments de base APRES avoir cloné
    mkdir -p ../modules/$MODULE/repository/scripts/versions
    if [ ! -f "../modules/$MODULE/repository/scripts/.git" ];
    then
        touch ../modules/$MODULE/repository/scripts/depends.ini
    fi

done
