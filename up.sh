#!/usr/bin/env bash
path_to_devtools="$(dirname "$0")"
pushd $path_to_devtools > /dev/null
echo "Update DEVTOOLS"
(git pull | grep -v "Already up-to-date")

echo
echo "Update INSTALLER"
(cd ../www/install && git pull | grep -v "Already up-to-date")

echo
echo "Update WWW"
(cd ../www/trunk && git pull | grep -v "Already up-to-date" && git submodule update && git submodule foreach git pull | grep -v "Already up-to-date")

echo
echo "Update modules"
g=`ls -d ../modules/*/trunk/.git`
for repo in ${g[@]}
do
    echo -n " - "
    echo "$repo" | cut -d"/" -f 3
    (cd ${repo} && cd ../../trunk && git pull | grep -v "Already up-to-date")
    (cd ${repo} && cd ../../repository/scripts && git pull | grep -v "Already up-to-date")
done

echo
echo "--------------------------------------------------"
echo "Now you should update the repository, by running: "
echo "$path_to_devtools/update_repository.sh "
echo "--------------------------------------------------"

popd > /dev/null
