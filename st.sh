#!/bin/bash
echo "Update DEVTOOLS"
(git status -sb | grep -v '## master')

echo
echo "Update INSTALLER"
(cd ../www/install && git status -sb | grep -v '## master')

echo
echo "Update WWW"
(cd ../www/trunk && git status -sb | grep -v '## master')

echo
echo "Update modules"
g=`ls -d ../modules/*/trunk/.git`
for repo in ${g[@]}
do
    echo
    echo " - ${repo:11:-11}" 
    (cd ${repo} && cd ../../trunk && git status -sb | grep -v '## master')
    echo " - ${repo:11:-11} (scripts)" 
    (cd ${repo} && cd ../../repository/scripts && git status -sb | grep -v '## master')
done
