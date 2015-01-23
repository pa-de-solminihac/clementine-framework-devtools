#!/usr/bin/env bash
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
    MSG1=$(cd $repo && cd ../../trunk && $GIT status -sb | grep -v '## ' | sed 's/^/    /g' && git log --oneline $(git describe --abbrev=0 --tags).. | sed 's/^/    /g')
    # echo " - $module_name (scripts)"
    MSG2=$(cd $repo && cd ../../repository/scripts && $GIT status -sb | grep -v '## ' | sed 's/^/    /g')
    if [[ "$MSG1" != "" || "$MSG2" != ""  ]]; then
        if [[ "$MSG1" != "" ]]; then
            echo "  ${BLUE}$module_name${NORMAL} ${DEEPBLUE}trunk${NORMAL}"
            echo "$MSG1";
        fi
        if [[ "$MSG2" != "" ]]; then
            echo "  ${BLUE}$module_name${NORMAL} ${DEEPBLUE}scripts${NORMAL}"
            echo "$MSG2";
        fi
    fi
done

popd > /dev/null
