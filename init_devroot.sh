#!/bin/bash
echo
echo "Ce script va créer dans : $(dirname $0)/clementine"
echo "les outils permettant de gérer un dépôt Clémentine."
echo
read -p "Voulez-vous vraiment continuer (o/N) ?" -n 1 -r
echo
if [[ $REPLY =~ ^[YyOo]$ ]]
then

    echo
    echo "=========================="
    echo "Création de l'arborescence"
    echo "=========================="
    echo
    mkdir -p clementine
    cd clementine &&  mkdir -p www modules releases repository

    # structure
    git clone git@github.com:pa-de-solminihac/clementine-framework-installer.git www/install && \
    git clone git@github.com:pa-de-solminihac/clementine-framework www/trunk && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-devtools devtools && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-git-hooks git-hooks && \

    echo
    echo "==================================="
    echo "Récupération des dépôts des modules"
    echo "==================================="
    echo

    # modules
    # generer la liste : devtools/generate_modules.list.sh
    for $module_name in $(cat devtools/modules.list); 
    do 
        mkdir -p modules/$module_name/repository && \
        git clone git@github.com:pa-de-solminihac/clementine-framework-module-$module_name modules/$module_name/trunk && \
        git clone git@github.com:pa-de-solminihac/clementine-framework-module-$module_name-scripts modules/$module_name/repository/scripts
    done

    echo
    echo "========================="
    echo "Mise à jour du repository"
    echo "========================="
    echo

    cd devtools && ./update_repository.sh

fi
