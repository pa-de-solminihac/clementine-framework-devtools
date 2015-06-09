#!/bin/bash

usage() {

    echo "Usage : `basename $0` <package>"

    cat <<EOF
Regénère le fichier depends.ini du package <package> à partir des fichiers etc/module.ini de chaque dernière version mineure d'une version majeure

    <package> est le nom du package

    Le résultat sera /clementine/modules/<package>/repository/scripts/depends.ini

EOF
    exit 0
}

# help
if [ "$#" != 1 ]
then
    usage
fi

PACKAGE=$1
# listes les versions mineures maxi pour chaque version majeure
LISTE=""
cd ../modules/$PACKAGE/repository/scripts/versions && LISTE=$(ls -d *.*/ | sed 's/\///g')
if [[ "$LISTE" == "" ]]
then
    echo "Pas de versions pour $PACKAGE";
    exit
fi
LAST=$(echo "$LISTE" | tail -n 1)
LAST_MAJ=$(echo $LAST | sed 's/\..*//g')

# pour chaque derniere version mineure de chaque version majeure...
DEPENDS_INI="";
for i in $(seq 1 $LAST_MAJ)
    do
        LAST_VERSION=$(echo "$LISTE" | grep "^$i\." | tail -n 1)
        # echo "Derniere version mineure d'une version majeure :"
        echo "*** ATTENTION *** : bien verifier la coherence du fichier module.ini dans le zip suivant avant de continuer :"
        echo "vim ../repository/clementine-framework-module-$PACKAGE/archive/$LAST_VERSION.zip"

        # extrait les informations de dependances du package $LAST_VERSION
        DEPENDS_INI="$DEPENDS_INI
$(unzip -p ../../../../../repository/clementine-framework-module-$PACKAGE/archive/$LAST_VERSION.zip clementine-framework-module-$PACKAGE-$LAST_VERSION/etc/module.ini | grep -A 1000 "^\[depends_$i\+\]" && echo "")"
done;

echo "$DEPENDS_INI" > ../depends.ini

echo "Le fichier ../modules/$PACKAGE/repository/scripts/depends.ini à été mis a jour :"
cat ../depends.ini

echo
echo
echo "Il faut maintenance le commiter, puis lancer ./update_repository.sh"
