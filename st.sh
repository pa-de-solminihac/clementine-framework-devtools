#!/usr/bin/env bash
RED=`echo -e '\033[0m\033[1;31m'`
DEEPGREEN=`echo -e '\033[0m\033[32m'`
GREEN=`echo -e '\033[0m\033[1;32m'`
NORMAL=`echo -e '\033[0m'`
GIT="git -c color.ui=always"
PATH_TO_DEVTOOLS="$(dirname "$0")"
pushd $PATH_TO_DEVTOOLS > /dev/null
echo "${DEEPGREEN}Status DEVTOOLS${NORMAL}"
($GIT status -sb | grep -v '## ')

echo
echo "${DEEPGREEN}Status GIT-HOOKS${NORMAL}"
(cd ../git-hooks && $GIT status -sb | grep -v '## ')

echo
echo "${DEEPGREEN}Status INSTALLER${NORMAL}"
(cd ../www/install && $GIT status -sb | grep -v '## ')

echo
echo "${DEEPGREEN}Status WWW${NORMAL}"
(cd ../www/trunk && $GIT status -sb | grep -v '## ')

echo
echo "${DEEPGREEN}Status modules${NORMAL}"
g=`ls -d ../modules/*/trunk/.git`
for repo in ${g[@]}
do
    module_name="$(echo "$repo" | cut -d "/" -f 3)"
    echo "  $module_name"
    (cd $repo && cd ../../trunk && $GIT status -sb | grep -v '## ' | sed 's/^/    /g')
    # echo " - $module_name (scripts)" 
    (cd $repo && cd ../../repository/scripts && $GIT status -sb | grep -v '## ' | sed 's/^/    /g')
done

popd > /dev/null
