#!/bin/bash

# Pour créer une nouvelle version d'un package, lancer ./create_package PACKAGE N.m et suivez les instructions
#
# Si vous voulez créer un nouveau package 1.0, il faut :
# - 2 github repositories:
#         clementine-module-PACKAGE
#         clementine-module-PACKAGE-scripts
# - set collaborators on both if necessary
# - clone clementine-module-PACKAGE in modules/PACKAGE/trunk
# - clone clementine-module-PACKAGE-scripts in modules/PACKAGE/repository/scripts
# - generate modules/PACKAGE/repository/scripts/depends.ini
# - generate basic package structure with "create_module_structure.sh PACKAGE"
# - move "PACKAGE/*" to "modules/PACKAGE/trunk" (you can rmdir remaining PACKAGE directory)
# - create_package PACKAGE 1.0 and follow instructions.
# - dont forget to "git push -u origin master" when you push on a repository the first time
#
# The package is ready. How you can publish your package:
# - cd devtools
# - add PACKAGE to modules.list
# - git pull
# - ./up.sh
# - ./update_repository.sh

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

#help
if [[ "$#" != 2 && "$#" != 3 ]]
then
    usage
fi

#parameters
PACKAGE="$1"
VERSION="$2"
SRC="trunk"
VERSION_MAJ=$(echo "$VERSION" | sed 's/\..*//g')
PACKAGE_UPPERCASE="$(echo "$PACKAGE" | tr '[:lower:]' '[:upper:]')"
if [[ "$#" == 3 ]]
then
    SRC="$3"
fi

#integrity check
if [[ "version=$VERSION" != "$(grep -o 'version=.*' ../modules/$PACKAGE/$SRC/etc/module.ini)" ]]
then
    echo "Version mismatch in module.ini !"
    exit 1
fi

GREPPED_VERSION="$(grep -o '^\[depends_[0-9]\+\]' ../modules/$PACKAGE/$SRC/etc/module.ini)"
if [[ "[depends_$VERSION_MAJ]" != "$GREPPED_VERSION" && "$GREPPED_VERSION" != "" ]]
then
    echo "Dependencies mismatch in module.ini !"
    exit 1
fi

cd ../modules/$PACKAGE && \
    #cp -pr $SRC $PACKAGE && \
    #zip -r $PACKAGE-$VERSION.zip $PACKAGE -x *.svn* *.git* && \
    #rm -rf $PACKAGE && \
    #mv $PACKAGE-$VERSION.zip repository/src/ && \
    cd repository/scripts && \
    mkdir -p versions/$VERSION && \
    touch versions/$VERSION/.gitignore && \
    #rm -rf scripts.zip && \
    #zip -r scripts.zip scripts -x *.svn* *.git* && \
    git add versions/$VERSION
    git add versions/$VERSION/.gitignore
    git add versions/$VERSION/*
    git commit -m "$PACKAGE $VERSION"
    cd ../../trunk

#TODO: mettre à jour le fichier module/.../repository/scripts.zip du repository avec les dependances pour cette version si nécessaire
#rappel : le fichier module/repository/scripts.zip est destiné au repository, et contient toutes les dépendances pour toutes les versions du module
#cd ../devtools && ./update_package_scripts.sh $PACKAGE $VERSION

# set commit message template
echo "$PACKAGE_UPPERCASE $VERSION

feat(scope): A new feature
fix(scope): A bug fix
docs(scope): Documentation only changes
style(scope): Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
refactor(scope): A code change that neither fixes a bug nor adds a feature
perf(scope): A code change that improves performance
test(scope): Adding missing tests
chore(scope): Changes to the build process or auxiliary tools and libraries such as documentation generation
" > /tmp/.clementine_create_package_commit_template.txt

#echo -e "$PACKAGE_UPPERCASE $VERSION\n\nchore(upgrade): CORE 5.0 and new clementine-framework .htaccess compatibility\n" > /tmp/.clementine_create_package_commit_message.txt

cat <<EOF

#Penser à lancer up.sh afin de récupérer les paquets à jour !

#C'est presque prêt, il faut maintenant lancer les commandes ci-dessous,
#en mettant un message de commit de la forme :
#MODULE N.m
#
#par exemple :
#
#USERS 4.9
#Amélioration de la procédure de renouvellement de mot de passe
#Messages plus clairs, meilleure cinématique, alerte l'utilisateur si son compte est désactivé.

cd ../modules/$PACKAGE/trunk
git pull
git add --all
git commit -t /tmp/.clementine_create_package_commit_template.txt
#git commit -F /tmp/.clementine_create_package_commit_message.txt

#================================================
# C'est le moment d'écrire le message de commit !
#================================================

git tag -a $VERSION -m "\$(git log -1 --pretty=%B)"
git push
git push --tags
cd ../repository/scripts
git add --all
git commit
git push
cd ../../../../devtools

#Il faut maintenant aller mettre à jour le dépot sur clementine.quai13.com :
#on se connecte en SSH et on lance :

cd www/devtools
git pull; ./update_repository.sh

EOF

