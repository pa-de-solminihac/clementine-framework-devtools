#!/bin/bash
echo "Update DEVTOOLS"
(git pull | grep -v "Already up-to-date")

echo
echo "Update INSTALLER"
(cd ../www/install && git pull | grep -v "Already up-to-date")

echo
echo "Update WWW"
(cd ../www/trunk && git pull | grep -v "Already up-to-date")

echo
echo "Update modules"
g=`ls -d ../modules/*/trunk/.git`
for repo in ${g[@]}
do
    echo " - ${repo:11:-11}" 
    (cd ${repo} && cd ../../trunk && git pull | grep -v "Already up-to-date")
    (cd ${repo} && cd ../../repository/scripts && git pull | grep -v "Already up-to-date")
done

echo
echo "Update repository"
./update_repository.sh
