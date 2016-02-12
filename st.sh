#!/usr/bin/env bash

SORT="$(which gsort)"
if [ ! -x $SORT ];
then
    SORT="sort"
fi

TAC="$(which gtac)"
if [ ! -x $TAC ];
then
    TAC="tac"
fi

SED="$(which gsed)"
if [ ! -x $sed ];
then
    SED="sed"
fi

#paths
GIT="git -c color.ui=always"
PATH_TO_DEVTOOLS="$(dirname "$0")"
#colors
RED=`echo -e '\033[0m\033[1;31m'`
DEEPRED=`echo -e '\033[0m\033[0;31m'`
GREEN=`echo -e '\033[0m\033[1;32m'`
DEEPGREEN=`echo -e '\033[0m\033[32m'`
YELLOW=`echo -e '\033[0m\033[1;33m'`
DEEPYELLOW=`echo -e '\033[0m\033[0;33m'`
BLUE=`echo -e '\033[0m\033[1;34m'`
DEEPBLUE=`echo -e '\033[0m\033[0;34m'`
NORMAL=`echo -e '\033[0m'`

pushd $PATH_TO_DEVTOOLS > /dev/null
MSG=$($GIT status -sb | grep -v '## ')
if [[ "$MSG" != "" ]]; then
    echo "${DEEPGREEN}DEVTOOLS status${NORMAL}"
    echo "$MSG"
    echo
fi

MSG=$(cd ../git-hooks && $GIT status -sb | grep -v '## ')
if [[ "$MSG" != "" ]]; then
    echo "${DEEPGREEN}GIT-HOOKS status${NORMAL}"
    echo "$MSG"
    echo
fi

MSG=$(cd ../www/install && $GIT status -sb | grep -v '## ')
if [[ "$MSG" != "" ]]; then
    echo "${DEEPGREEN}INSTALLER status${NORMAL}"
    echo "$MSG"
    echo
fi

MSG=$(cd ../www/trunk && $GIT status -sb | grep -v '## ')
if [[ "$MSG" != "" ]]; then
    echo "${DEEPGREEN}WWW status${NORMAL}"
    echo "$MSG"
    echo
fi

echo "${DEEPGREEN}MODULES status${NORMAL}"
g=`ls -d ../modules/*/trunk/.git`
for repo in ${g[@]}
do
    module_name="$(echo "$repo" | cut -d "/" -f 3)"
    MSG1=$(cd $repo && cd ../../trunk && $GIT status -sb | grep -v '##.*master.*origin/master' | $SED 's/^/    /g' && git log --oneline $(git describe --abbrev=0 --tags).. | $SED 's/^/    /g')
    # echo " - $module_name (scripts)"
    MSG2=$(cd $repo && cd ../../repository/scripts && $GIT status -sb | grep -v '##.*master.*origin/master' | $SED 's/^/    /g')
    # liste des commit (poussés ou non) depuis la dernière version publiée
    #MSG3="$(cd $repo && cd ../../repository/scripts/versions && LISTE=$(ls -d *.*/ | $SORT -V | $SED 's/\///g') && LAST=$(echo "$LISTE" | tail -n 1) && LAST_MAJ=$(echo $LAST | $SED 's/\..*//g') && git log | head -n 1000 | grep -iB 1000 "^ *$module_name $LAST" | $TAC | $SED "1,5{d}" | $TAC)"
    #MSG3="$(cd $repo && cd ../../repository/scripts/versions && LISTE=$(ls -d *.*/ | $SORT -V | $SED 's/\///g') && LAST=$(echo "$LISTE" | tail -n 1) && LAST_MAJ=$(echo $LAST | $SED 's/\..*//g') && git log --all --pretty=oneline | head -n 1000 | grep -iB 1000 "^[a-f0-9]\+ *$module_name $LAST$" | grep -v "^[a-f0-9]\+ *$module_name $LAST$")"
    if [[ "$MSG1" != "" || "$MSG2" != "" || "$MSG3" != "" ]]; then
        if [[ "$MSG1" != "" ]]; then
            echo "  ${BLUE}$module_name${NORMAL} ${DEEPBLUE}trunk${NORMAL}"
            echo "$MSG1";
        fi
        if [[ "$MSG2" != "" ]]; then
            echo "  ${BLUE}$module_name${NORMAL} ${DEEPBLUE}scripts${NORMAL}"
            echo "$MSG2";
        fi
        if [[ "$MSG3" != "" ]]; then
            echo "  ${RED}$module_name${NORMAL} ${DEEPRED}scripts${NORMAL}"
            echo "$MSG3";
        fi
    fi
done

popd > /dev/null
