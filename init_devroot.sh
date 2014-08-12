#!/bin/bash
echo
echo "Ce script va créer dans : $(dirname $0)/clementine"
echo "les outils permettant de gérer un dépôt Clémentine."
echo
read -p "Voulez-vous vraiment continuer (o/N) ?" -n 1 -r
echo
if [[ $REPLY =~ ^[YyOo]$ ]]
then

    mkdir -p clementine
    cd clementine &&  mkdir -p www modules releases repository

    # structure
    git clone git@github.com:pa-de-solminihac/clementine-framework-installer.git www/install && \
    git clone git@github.com:pa-de-solminihac/clementine-framework www/trunk && \
    # obsolete
    # git clone git@github.com:pa-de-solminihac/clementine-framework-releases ../releases
    git clone git@github.com:pa-de-solminihac/clementine-framework-devtools devtools && \

    # modules
    # generer la liste : find modules -type d -name '.git' | awk -F"/" '{print $2}' | sort | uniq
    mkdir -p modules/categories/repository && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-categories modules/categories/trunk && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-categories-scripts modules/categories/repository/scripts && \
    mkdir -p modules/cms/repository && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-cms modules/cms/trunk && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-cms-scripts modules/cms/repository/scripts && \
    mkdir -p modules/contact/repository && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-contact modules/contact/trunk && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-contact-scripts modules/contact/repository/scripts && \
    mkdir -p modules/contenus/repository && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-contenus modules/contenus/trunk && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-contenus-scripts modules/contenus/repository/scripts && \
    mkdir -p modules/contenus_html/repository && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-contenus_html modules/contenus_html/trunk && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-contenus_html-scripts modules/contenus_html/repository/scripts && \
    mkdir -p modules/contenus_intro_chapo_texte/repository && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-contenus_intro_chapo_texte modules/contenus_intro_chapo_texte/trunk && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-contenus_intro_chapo_texte-scripts modules/contenus_intro_chapo_texte/repository/scripts && \
    mkdir -p modules/contenus_introck/repository && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-contenus_introck modules/contenus_introck/trunk && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-contenus_introck-scripts modules/contenus_introck/repository/scripts && \
    mkdir -p modules/core/repository && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-core modules/core/trunk && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-core-scripts modules/core/repository/scripts && \
    mkdir -p modules/cron/repository && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-cron modules/cron/trunk && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-cron-scripts modules/cron/repository/scripts && \
    mkdir -p modules/crud/repository && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-crud modules/crud/trunk && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-crud-scripts modules/crud/repository/scripts && \
    mkdir -p modules/cssjs/repository && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-cssjs modules/cssjs/trunk && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-cssjs-scripts modules/cssjs/repository/scripts && \
    mkdir -p modules/db/repository && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-db modules/db/trunk && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-db-scripts modules/db/repository/scripts && \
    mkdir -p modules/debug/repository && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-debug modules/debug/trunk && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-debug-scripts modules/debug/repository/scripts && \
    mkdir -p modules/errors/repository && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-errors modules/errors/trunk && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-errors-scripts modules/errors/repository/scripts && \
    mkdir -p modules/fonctions/repository && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-fonctions modules/fonctions/trunk && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-fonctions-scripts modules/fonctions/repository/scripts && \
    mkdir -p modules/galerie/repository && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-galerie modules/galerie/trunk && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-galerie-scripts modules/galerie/repository/scripts && \
    mkdir -p modules/ie6nomore/repository && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-ie6nomore modules/ie6nomore/trunk && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-ie6nomore-scripts modules/ie6nomore/repository/scripts && \
    mkdir -p modules/jstools/repository && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-jstools modules/jstools/trunk && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-jstools-scripts modules/jstools/repository/scripts && \
    mkdir -p modules/mail/repository && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-mail modules/mail/trunk && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-mail-scripts modules/mail/repository/scripts && \
    mkdir -p modules/nusoap/repository && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-nusoap modules/nusoap/trunk && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-nusoap-scripts modules/nusoap/repository/scripts && \
    mkdir -p modules/skinbo/repository && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-skinbo modules/skinbo/trunk && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-skinbo-scripts modules/skinbo/repository/scripts && \
    mkdir -p modules/sms/repository && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-sms modules/sms/trunk && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-sms-scripts modules/sms/repository/scripts && \
    mkdir -p modules/users/repository && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-users modules/users/trunk && \
    git clone git@github.com:pa-de-solminihac/clementine-framework-module-users-scripts modules/users/repository/scripts && \

    echo && \
    echo "Fin des clone."

    echo "Maintenant il faut aller dans le dossier devtools et lancer ./update_repository.sh"

fi
