#!/bin/bash

usage() {

    echo "Usage : `basename $0` <package> <version> [dir_src]"

    cat <<EOF
Cree un fichier zip pour le package <package> à partir de sa branche trunk par défaut (ie. à partir du dossier /clementine/modules/<package>/trunk)

    <package> est le nom du package
    <version> est le numéro de version (format X.y) du package à créer 
    [dir_src] est le sous dossier de /clementine/modules/<package>/ qui contient les sources du module. Par défaut, c'est trunk

    Le résultat sera /clementine/modules/<package>/repository/src/<package>-<version>.zip

EOF
    exit 0
}

# help
if [[ "$#" != 2 && "$#" != 3 ]]
then
    usage
fi

PACKAGE=$1
VERSION=$2
SRC="trunk"
if [[ "$#" == 3 ]]
then
    SRC=$3
fi
cd ../modules/$PACKAGE && \
    # cp -pr $SRC $PACKAGE && \
    # zip -r $PACKAGE-$VERSION.zip $PACKAGE -x *.svn* *.git* && \
    # rm -rf $PACKAGE && \
    # mv $PACKAGE-$VERSION.zip repository/src/ && \
    cd repository/scripts && \
    mkdir --parents versions/$VERSION && \
    touch versions/$VERSION/.gitignore && \
    # rm -rf scripts.zip && \
    # zip -r scripts.zip scripts -x *.svn* *.git* && \
    git add versions/$VERSION
    git add versions/$VERSION/.gitignore
    git add versions/$VERSION/*
    git commit -m "$PACKAGE $VERSION"
    cd ../../trunk

# TODO: mettre à jour le fichier module/.../repository/scripts.zip du repository avec les dependances pour cette version si nécessaire
# rappel : le fichier module/repository/scripts.zip est destiné au repository, et contient toutes les dépendances pour toutes les versions du module
# cd ../devtools && ./update_package_scripts.sh $PACKAGE $VERSION

cat <<EOF

TODO :
cd ../modules/$PACKAGE/trunk
(...)
git add stuff
git commit stuff
(...)
git tag -a $VERSION -m "version $VERSION"
git push
git push --tags
cd ../repository/scripts
git push

RAPPEL : 
    le fichier module/.../etc/module.ini est destiné au site, et contient les dépendances pour LA version X du module

EOF

