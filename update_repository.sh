#!/bin/bash
CLEMENTINE_REPOSITORY_URL="https://github.com/pa-de-solminihac"
PAUSE_TIME=1

# recupere la liste des modules dispo dans le dossier ../modules/
MODULES=`ls -d ../modules/*/trunk/.git`

# TODO: faire prendre en compte les arguments suivants
#--package           : ne recupere que le package X
#--version           : ne recupere que la version N.m du package X
#--only-scripts      : ne recupere que les scripts
#--only-packages     : ne recupere que les packages
#--repository-url    : utilise le repository X

# on cree le dossier repository s'il n'existe pas deja et on entre dedans
echo
echo "Creating/updating the whole repository"
mkdir -p ../repository
cd ../repository

echo
echo "Getting packages scripts"
for MODULE_PATH in ${MODULES[@]}
do
    MODULE="${MODULE_PATH:11:-11}";
    # recupere les scripts du module
    mkdir -p clementine-framework-module-$MODULE-scripts/archive;
    echo -n "Downloading scripts for : $MODULE";
    wget -q $CLEMENTINE_REPOSITORY_URL/clementine-framework-module-$MODULE-scripts/archive/master.zip -O clementine-framework-module-$MODULE-scripts/archive/master.zip;
    if [[ $? == 0 ]]; then
        echo "    ... ok"
    else
        echo "    ... failed"
        exit
    fi
    # soyons cool avec github
    sleep $PAUSE_TIME;
done

echo
echo "Getting packages versions"
for MODULE_PATH in ${MODULES[@]}
do
    MODULE="${MODULE_PATH:11:-11}";
    mkdir -p clementine-framework-module-$MODULE/archive;
    # recupere toutes les versions dispo du module
    VERSIONS_DISPO=$(zip --show-files clementine-framework-module-$MODULE-scripts/archive/master.zip | grep "/versions/." | cut -d"/" -f 3 | sort -V | uniq)
    for VERSION in ${VERSIONS_DISPO[@]};
    do
        # si le fichier n'existe pas deja ou s'il a mal été téléchargé on le télécharge
        zip -T clementine-framework-module-$MODULE/archive/$VERSION.zip > /dev/null 2>&1;
        if [[ $? > 0 ]]; then
            echo -n "Downloading module : $MODULE $VERSION";
            rm -f clementine-framework-module-$MODULE/archive/$VERSION.zip;
            wget -q $CLEMENTINE_REPOSITORY_URL/clementine-framework-module-$MODULE/archive/$VERSION.zip -O clementine-framework-module-$MODULE/archive/$VERSION.zip;
            if [[ $? == 0 ]]; then
                echo "    ... ok"
            else
                echo "    ... failed"
                exit
            fi
            # soyons cool avec github
            sleep $PAUSE_TIME;
        # else
            # echo "Skipping module : $MODULE $VERSION, already ok";
        fi
    done;
done

# retour au repertoire d'origine
cd ../devtools
