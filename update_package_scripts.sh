#!/bin/bash

usage() {

    echo "Usage : `basename $0` <package> <version>"

    cat <<EOF
Repackage les scripts de mise à jour du package <package> à partir des fichiers php (ie. à partir du dossier /clementine/modules/<package>/repository/scripts/versions/<version>)

    <package> est le nom du package
    <version> est le numéro de version (format X.y) du package

    Le résultat sera /clementine/modules/<package>/repository/scripts.zip

EOF
    exit 0
}

# help
if [ "$#" != 2 ]
then
    usage
fi

PACKAGE=$1
VERSION=$2

./update_package_depends.sh $PACKAGE

cd ../modules/$PACKAGE && \
    cd repository && \
    rm -rf scripts.zip && \
    zip -r scripts.zip scripts -x *.svn* *.git* && \
    mkdir --parents scripts/versions/$VERSION && \
    cd ../../ && \
    git add ../modules/$PACKAGE
    git add ../modules/$PACKAGE/repository/scripts/versions/$VERSION
    git add ../modules/$PACKAGE/repository/scripts/versions/$VERSION/*

