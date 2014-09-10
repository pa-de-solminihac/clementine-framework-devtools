#!/usr/bin/env bash
path_to_devtools="$(dirname "$0")"
pushd $path_to_devtools > /dev/null
echo "Update DEVTOOLS"
(git pull | grep -v "Already up-to-date")

echo
echo "Update GIT-HOOKS"
(cd ../git-hooks && git pull | grep -v "Already up-to-date")

echo
echo "Update INSTALLER"
(cd ../www/install && git pull | grep -v "Already up-to-date")

echo
echo "Update WWW"
(cd ../www/trunk && git pull | grep -v "Already up-to-date" && git submodule update && git submodule foreach git pull | grep -v "Already up-to-date")

# detecte si GNU Paralllel est disponible
# O. Tange (2011): GNU Parallel - The Command-Line Power Tool,
# ;login: The USENIX Magazine, February 2011:42-47.
which parallel > /dev/null
NOPARALLEL=$?

echo
echo "Update modules"
g=`ls -d ../modules/*/trunk/.git`
if [[ $NOPARALLEL > 0 ]];
then
    for repo in ${g[@]}
    do
        echo -n " - "
        echo "$repo" | cut -d"/" -f 3
        (cd ${repo} && cd ../../trunk && git pull | grep -v "Already up-to-date")
        (cd ${repo} && cd ../../repository/scripts && git pull | grep -v "Already up-to-date")
    done
else
    echo "${g[@]}" | parallel --gnu -j8 '
        echo -n " - "
        echo "{}" | cut -d"/" -f 3
        (cd {} && cd ../../trunk && git pull | grep -v "Already up-to-date")
        (cd {} && cd ../../repository/scripts && git pull | grep -v "Already up-to-date")
    '
fi

echo
echo "--------------------------------------------------"
echo "Now you should update the repository, by running: "
echo "$path_to_devtools/update_repository.sh "
echo "--------------------------------------------------"

popd > /dev/null
