#!/usr/bin/env bash
RED=`echo -e '\033[0m\033[1;31m'`
DEEPGREEN=`echo -e '\033[0m\033[32m'`
GREEN=`echo -e '\033[0m\033[1;32m'`
NORMAL=`echo -e '\033[0m'`
GIT="git -c color.ui=always"
path_to_devtools="$(dirname "$0")"
pushd $path_to_devtools > /dev/null
echo "${DEEPGREEN}Update DEVTOOLS${NORMAL}"
($GIT pull | grep -v "Already up-to-date")

echo
echo "${DEEPGREEN}Update GIT-HOOKS${NORMAL}"
(cd ../git-hooks && $GIT pull | grep -v "Already up-to-date")

echo
echo "${DEEPGREEN}Update INSTALLER${NORMAL}"
(cd ../www/install && $GIT pull | grep -v "Already up-to-date")

echo
echo "${DEEPGREEN}Update WWW${NORMAL}"
(cd ../www/trunk && $GIT pull | grep -v "Already up-to-date" && $GIT submodule update && $GIT submodule foreach git pull | grep -v "Already up-to-date")

# detecte si GNU Paralllel est disponible
# O. Tange (2011): GNU Parallel - The Command-Line Power Tool,
# ;login: The USENIX Magazine, February 2011:42-47.
which parallel > /dev/null
NOPARALLEL=$?

echo
echo "${DEEPGREEN}Update modules${NORMAL}"
#./generate_modules.list.sh
MODULES="$(cat modules.list)"
if [[ $NOPARALLEL > 0 ]];
then
    for repo in ${MODULES[@]}
    do
        echo -n "  "
        echo "$repo"
        if [ -d "../modules/$MODULE" ];
        then
            (cd ../modules/${repo}/trunk && $GIT pull | grep -v 'Already up-to-date' | sed 's/^/    /g')
            (cd ../modules/${repo}/repository/scripts && $GIT pull | grep -v 'Already up-to-date' | sed 's/^/    /g')
        else
            echo "    $MODULE (from modules.list) is not present in ../modules/"
        fi
    done
else
    echo "${MODULES[@]}" | parallel --gnu -j8 "
        echo -n '  '
        echo '{}'
        if [ -d '../modules/{}' ];
        then
            (cd ../modules/{}/trunk && $GIT pull | grep -v 'Already up-to-date' | sed 's/^/    /g')
            (cd ../modules/{}/repository/scripts && $GIT pull | grep -v 'Already up-to-date' | sed 's/^/    /g')
        else
            echo '    {} (from modules.list) is not present in ../modules/'
        fi
    "
fi

echo
echo "--------------------------------------------------"
echo "Now you should update the repository, by running: "
echo "$path_to_devtools/update_repository.sh "
echo "--------------------------------------------------"

popd > /dev/null
