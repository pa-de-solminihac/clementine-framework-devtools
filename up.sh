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
g=`ls -d ../modules/*/trunk/.git`
if [[ $NOPARALLEL > 0 ]];
then
    for repo in ${g[@]}
    do
        echo -n "  "
        echo "$repo" | cut -d"/" -f 3
        (cd ${repo} && cd ../../trunk && $GIT pull | grep -v "Already up-to-date" | sed 's/^/    /g')
        (cd ${repo} && cd ../../repository/scripts && $GIT pull | grep -v "Already up-to-date" | sed 's/^/    /g')
    done
else
    echo "${g[@]}" | parallel --gnu -j8 "
        echo -n '  '
        echo '{}' | cut -d'/' -f 3
        (cd {} && cd ../../trunk && $GIT pull | grep -v 'Already up-to-date' | sed 's/^/    /g')
        (cd {} && cd ../../repository/scripts && $GIT pull | grep -v 'Already up-to-date' | sed 's/^/    /g')
    "
fi

echo
echo "--------------------------------------------------"
echo "Now you should update the repository, by running: "
echo "$path_to_devtools/update_repository.sh "
echo "--------------------------------------------------"

popd > /dev/null
