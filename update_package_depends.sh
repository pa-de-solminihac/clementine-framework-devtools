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
cd ../modules/$PACKAGE/repository/src && LISTE=$(ls $PACKAGE-*.zip | sed 's/^.*-//g' | sed 's/\.zip//g' | sort -V)
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
        echo "vim ../modules/$PACKAGE/repository/src/$PACKAGE-$LAST_VERSION.zip"
        # extrait les informations de dependances du package $LAST_VERSION
        DEPENDS_INI="$DEPENDS_INI
$(unzip -p $PACKAGE-$LAST_VERSION.zip $PACKAGE/etc/module.ini | grep -A 1000 "^\[depends_$i\+\]" && echo "")"
done;

echo "$DEPENDS_INI" > ../scripts/depends.ini

# cat ../scripts/depends.ini
echo "Lancer update_package_scripts"
