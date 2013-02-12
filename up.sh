#!/bin/bash
echo "Update DEVTOOLS"
(git pull)

echo
echo "Update INSTALLER"
(cd ../www/install && git pull)

echo
echo "Update WWW"
(cd ../www/trunk && git pull)

echo
echo "Update modules"
g=`ls -d ../modules/*/trunk/.git`
for repo in ${g[@]}
do
    echo " - ${repo:11:-11}" 
    (cd ${repo} && cd ../../trunk && git pull)
    (cd ${repo} && cd ../../repository/scripts && git pull)
done
