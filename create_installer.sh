#!/bin/bash

usage() {

    echo "Usage : `basename $0`"

    cat <<EOF
Cree un fichier zip pour la derniere version de l'installeur (ie. à partir du dossier /clementine/www/install)

    Le résultat sera /clementine/modules/install.zip

    Le script met aussi à jour le numéro de version de l'installeur dans /clementine/modules/install_latest.txt

EOF
    exit 0
}

# help
if [ "$#" != 0 ]
then
    usage
fi

date '+%Y%m%d%H%M%S' > ../modules/install_latest.txt && /bin/cp ../modules/install_latest.txt ../www/install/install_version.txt && cp -pr ../www/install . && rm -rf install/config.php install/tmp && zip -r install.zip install -x *.svn* *.git* config.php && rm -rf install && mv install.zip ../modules/install.zip

