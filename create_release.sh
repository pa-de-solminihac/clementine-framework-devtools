#!/bin/bash

# script obsolete, update_repository.sh le fait automatiquement
exit

SORT="$(which gsort)"
if [ ! -x $SORT ];
then
    SORT="sort"
fi

usage() {

    echo "Usage : `basename $0` <version>"

    cat <<EOF
Cree un fichier zip pour un nouveau projet à partir de la branche trunk (ie. à partir du dossier /clementine/www/trunk), et rajoute dedans la dernière version de l'installeur

    <version> est le numéro de version (format X.y) du package à créer 

    Le résultat sera /clementine/releases/clementine-<version>.zip

EOF
    exit 0
}

# help
if [ "$#" != 1 ]
then
    usage
fi

VERSION=$1
# le module core sera installé par l'installeur, qui choisira la bonne version
COREVERSION="`ls ../repository/clementine-framework-module-core/archive/*.zip | $SORT -V | tail -n 1 | sed 's/.*\///g' | sed 's/.zip//g'`"
cd ../releases && \
    cp -pr ../www/trunk clementine-$VERSION && \
    #rm -rf clementine-$VERSION/app && \
    mkdir -p clementine-$VERSION/app/share && \
    mkdir -p clementine-$VERSION/app/local/site/etc && \
    # cp -pr ../modules/core/repository/src/core-$COREVERSION.zip clementine-$VERSION/app/share/ && \
    # unzip -p ../repository/clementine-framework-module-core/archive/$COREVERSION.zip clementine-framework-module-core-$COREVERSION/etc/config.ini > clementine-$VERSION/app/local/site/etc/config.ini && \
    # rm clementine-$VERSION/app/share/core-$COREVERSION.zip && \
    # cp -pr clementine-$VERSION/app/share/core/etc/config.ini clementine-$VERSION/app/local/site/etc/config.ini
    # mkdir -p clementine-$VERSION/app/local/site/model && \
    # mkdir -p clementine-$VERSION/app/local/site/view && \
    # mkdir -p clementine-$VERSION/app/local/site/ctrl && \
    # mkdir -p clementine-$VERSION/app/local/site/skin && \
    rm -rf clementine-$VERSION/README.md && \
    rm -rf clementine-$VERSION/install/README.md && \
    cp -p ../www/trunk/.htaccess clementine-$VERSION && \
    rm -rf clementine-$VERSION/tmp && \
    mkdir -p clementine-$VERSION/tmp && \
    cp -p ../www/trunk/tmp/.htaccess clementine-$VERSION/tmp && \
    rm -rf clementine-$VERSION/install && \
    cp -pr ../www/install clementine-$VERSION && \
    rm -rf clementine-$VERSION/install/README.md && \
    rm -rf clementine-$VERSION/install/config.php && \
    rm -rf clementine-$VERSION/install/tmp && \
    rm -rf clementine-$VERSION.zip && \
    zip -r clementine-$VERSION.zip clementine-$VERSION -x *.git* && \
    rm -rf clementine-$VERSION && \
    cat <<EOF

Nouveau fichier créé : ../releases/clementine-$VERSION.zip

EOF
