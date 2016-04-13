#!/usr/bin/env bash

# default values
show_commits=0

# allowed parameters
OPT_ALL="--all"

# usage
function usage() {
    cat <<EOF
Affiche le "git status" de chaque repository (devtools, git-hooks, www, installer et tous les modules)
Usage: $(basename $0) [--all]
Options:
    $OPT_ALL			Affiche aussi tous les commits (poussés ou non) depuis la dernière version publiée
EOF
}

# parse parameters
while [ $# -ne 0 ]
do
    case "$1" in
        $OPT_ALL)
            show_commits=1
            ;;
        -h|--help|*)
            usage
            exit
            ;;
    esac
    shift
done

#paths
GIT="git -c color.ui=always"
PATH_TO_DEVTOOLS="$(dirname "$0")"
SORT="$(which gsort 2> /dev/null)"
if [ ! -x $SORT ];
then
    SORT="sort"
fi
TAC="$(which gtac 2> /dev/null)"
if [ ! -x $TAC ];
then
    TAC="tac"
fi
SED="$(which gsed 2> /dev/null)"
if [ ! -x "$SED" ];
then
    SED="sed"
fi
GREP="$(which ggrep 2> /dev/null)"
if [ ! -x "$GREP" ];
then
    GREP="grep"
fi
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

# main
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
    MSG1=$(cd $repo && cd ../../trunk && \
        git diff etc/module.ini | grep '\-version=\|+version=' | xargs | sed 's/-version=/     /g' | sed 's/+version=/=> /g' | sed "s/\.0$/${RED}.0${NORMAL}/g" && \
        $GIT status -sb | grep -v '## .....master' | $SED 's/^/    /g' && \
        git log --oneline $(git describe --abbrev=0 --tags).. | $SED 's/^/    /g'
    )
    # echo " - $module_name (scripts)"
    MSG2=$(cd $repo && cd ../../repository/scripts && $GIT status -sb | grep -v '## .....master' | $SED 's/^/    /g')
    # liste des commit (poussés ou non) depuis la dernière version publiée
    if [[ "$show_commits" != "0" ]]; then
        #MSG3="$(cd $repo && cd ../../repository/scripts/versions && LISTE=$(ls -d *.*/ | $SORT -V | $SED 's/\///g') && LAST=$(echo "$LISTE" | tail -n 1) && LAST_MAJ=$(echo $LAST | $SED 's/\..*//g') && git log | head -n 1000 | grep -iB 1000 "^ *$module_name $LAST" | $TAC | $SED "1,5{d}" | $TAC)"
        MSG3="$(cd $repo && cd ../../repository/scripts/versions && LISTE=$(ls -d *.*/ | $SORT -V | $SED 's/\///g') && LAST=$(echo "$LISTE" | tail -n 1) && LAST_MAJ=$(echo $LAST | $SED 's/\..*//g') && git log --abbrev-commit --all --pretty=oneline | head -n 1000 | $GREP -iB 1000 "^[a-f0-9]\+ *$module_name $LAST$" | $GREP -v "^[a-f0-9]\+ *$module_name $LAST$" | $SED 's/^/     /g' )"
    fi
    if [[ "$MSG1" != "" || "$MSG2" != "" || "$MSG3" != "" ]]; then
        if [[ "$MSG1" != "" ]]; then
            echo "  ${BLUE}$module_name${NORMAL} ${DEEPBLUE}trunk${NORMAL} "
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
