#!/bin/bash
CLEMENTINE_REPOSITORY_URL="https://github.com/pa-de-solminihac" # en dur lors des appels avec parallel
PAUSE_TIME=1

# detecte si GNU Paralllel est disponible
# O. Tange (2011): GNU Parallel - The Command-Line Power Tool,
# ;login: The USENIX Magazine, February 2011:42-47.
which parallel > /dev/null
NOPARALLEL=$?

# recupere la liste des modules dispo dans le dossier ../modules/
MODULES="$(ls -d ../modules/*/trunk/.git | sed 's/^...........//g' | sed 's/...........$//g')"

# TODO: faire prendre en compte les arguments suivants
#--package           : ne recupere que le package X
#--version           : ne recupere que la version N.m du package X
#--only-scripts      : ne recupere que les scripts
#--only-packages     : ne recupere que les packages
#--repository-url    : utilise le repository X

# on cree le dossier repository s'il n'existe pas deja et on entre dedans
echo
MSG="Creating/updating the whole repository";
echo -n "$MSG";
mkdir -p ../repository
cd ../repository
if [[ $? == 0 ]]; then
    let COL=70-${#MSG}
    printf "%${COL}s\n" "OK"
else
    let COL=70-${#MSG}
    printf "%${COL}s\n" "failed"
    exit
fi

echo
# recupere les scripts du module
MSG="Getting installer";
mkdir -p clementine-framework-installer/archive;
mkdir -p clementine-framework-installer/master;
echo -n "$MSG";
wget -q $CLEMENTINE_REPOSITORY_URL/clementine-framework-installer/archive/master.zip -O clementine-framework-installer/archive/master.zip && unzip -p clementine-framework-installer/archive/master.zip clementine-framework-installer-master/install_latest.txt > clementine-framework-installer/master/install_latest.txt && \
    # legacy : le lien de telechargement de l'installeur doit renvoyer l'installeur dans un format exploitable directement par l'utilisateur (ie. nom de dossier racine = install)
    cd clementine-framework-installer/archive && unzip -q master.zip && mv clementine-framework-installer-master install && zip --quiet -r install.zip install && rm -rf install && mv install.zip ../../../modules/install.zip && cd ../../
if [[ $? == 0 ]]; then
    let COL=70-${#MSG}
    printf "%${COL}s\n" "OK"
else
    let COL=70-${#MSG}
    printf "%${COL}s\n" "failed"
    exit
fi
# soyons cool avec github
sleep $PAUSE_TIME;

echo
MSG="Rebuilding latest release";
echo -n "$MSG";
mkdir -p clementine-framework;
cd clementine-framework && wget -q $CLEMENTINE_REPOSITORY_URL/clementine-framework/archive/master.zip -O master.zip && unzip -q master.zip && \
    cd clementine-framework-master && rmdir install && rm -f .gitmodules && cp ../../../modules/install.zip . && unzip -q install.zip && cd .. && mv clementine-framework-master clementine-framework && zip --quiet -r clementine-framework.zip clementine-framework && rm -rf clementine-framework && rm -f master.zip && cd ..
if [[ $? == 0 ]]; then
    let COL=70-${#MSG}
    printf "%${COL}s\n" "OK"
else
    let COL=70-${#MSG}
    printf "%${COL}s\n" "failed"
    exit
fi
# soyons cool avec github
sleep $PAUSE_TIME;

echo
echo "Getting packages scripts"
if [[ $NOPARALLEL > 0 ]];
then
    # sequential downloads
    for MODULE in ${MODULES[@]}
    do
        # recupere les scripts du module
        mkdir -p clementine-framework-module-$MODULE-scripts/archive;
        MSG="    $MODULE";
        echo -n "$MSG";
        wget -q $CLEMENTINE_REPOSITORY_URL/clementine-framework-module-$MODULE-scripts/archive/master.zip -O clementine-framework-module-$MODULE-scripts/archive/master.zip;
        if [[ $? == 0 ]]; then
            let COL=70-${#MSG}
            printf "%${COL}s\n" "OK"
        else
            let COL=70-${#MSG}
            printf "%${COL}s\n" "failed"
            exit
        fi
        # soyons cool avec github
        sleep $PAUSE_TIME;
    done
else
    # parallel downloads
    echo "${MODULES[@]}" | parallel --gnu -j8 '
        CLEMENTINE_REPOSITORY_URL="https://github.com/pa-de-solminihac";
        mkdir -p clementine-framework-module-{}-scripts/archive;
        MSG="    {}";
        echo -n "$MSG";
        wget -q $CLEMENTINE_REPOSITORY_URL/clementine-framework-module-{}-scripts/archive/master.zip -O clementine-framework-module-{}-scripts/archive/master.zip;
        if [[ $? == 0 ]]; then
            let COL=70-${#MSG}
            printf "%${COL}s\n" "OK"
        else
            let COL=70-${#MSG}
            printf "%${COL}s\n" "failed"
            exit
        fi
    '
fi

echo
echo "Getting packages versions"
DID_RECUP=0
for MODULE in ${MODULES[@]}
do
    mkdir -p clementine-framework-module-$MODULE/archive;
    # recupere toutes les versions dispo du module
    VERSIONS_DISPO=$(zip --show-files clementine-framework-module-$MODULE-scripts/archive/master.zip | grep "/versions/." | cut -d"/" -f 3 | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | uniq)
    for VERSION in ${VERSIONS_DISPO[@]};
    do
        # si le fichier n'existe pas deja ou s'il a mal été téléchargé on le télécharge
        zip -T clementine-framework-module-$MODULE/archive/$VERSION.zip > /dev/null 2>&1;
        if [[ $? > 0 ]]; then
            MSG="    $MODULE $VERSION";
            echo -n "$MSG";
            rm -f clementine-framework-module-$MODULE/archive/$VERSION.zip;
            wget -q $CLEMENTINE_REPOSITORY_URL/clementine-framework-module-$MODULE/archive/$VERSION.zip -O clementine-framework-module-$MODULE/archive/$VERSION.zip;
            if [[ $? == 0 ]]; then
                let COL=70-${#MSG}
                printf "%${COL}s\n" "OK"
            else
                let COL=70-${#MSG}
                printf "%${COL}s\n" "failed"
                exit
            fi
            DID_RECUP=1
            # soyons cool avec github
            sleep $PAUSE_TIME;
        # else
            # echo "Skipping module : $MODULE $VERSION, already ok";
        fi
    done;
done
if [[ $DID_RECUP == 0 ]]; then
    echo "    nothing new"
fi

# retour au repertoire d'origine
cd ../devtools
