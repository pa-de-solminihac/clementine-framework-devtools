#!/usr/bin/env bash
RED=`echo -e '\033[0m\033[1;31m'`
DEEPGREEN=`echo -e '\033[0m\033[32m'`
GREEN=`echo -e '\033[0m\033[1;32m'`
NORMAL=`echo -e '\033[0m'`
path_to_devtools="$(dirname "$0")"
pushd $path_to_devtools > /dev/null
echo "${DEEPGREEN}Status DEVTOOLS${NORMAL}"
(git -c color.ui=always status -sb | grep -v '## ')

echo
echo "${DEEPGREEN}Status GIT-HOOKS${NORMAL}"
(cd ../git-hooks && git -c color.ui=always status -sb | grep -v '## ')

echo
echo "${DEEPGREEN}Status INSTALLER${NORMAL}"
(cd ../www/install && git -c color.ui=always status -sb | grep -v '## ')

echo
echo "${DEEPGREEN}Status WWW${NORMAL}"
(cd ../www/trunk && git -c color.ui=always status -sb | grep -v '## ')

echo
echo "${DEEPGREEN}Status modules${NORMAL}"
g=`ls -d ../modules/*/trunk/.git`
for repo in ${g[@]}
do
    module_name="$(echo "$repo" | cut -d "/" -f 3)"
    echo "  $module_name"
    (cd $repo && cd ../../trunk && git -c color.ui=always status -sb | grep -v '## ' | sed 's/^/    /g')
    # echo " - $module_name (scripts)" 
    (cd $repo && cd ../../repository/scripts && git -c color.ui=always status -sb | grep -v '## ' | sed 's/^/    /g')
done

popd > /dev/null
