#!/usr/bin/env bash
path_to_devtools="$(dirname "$0")"
pushd $path_to_devtools > /dev/null
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
    module_name="$(echo "$repo" | cut -d "/" -f 3)"
    echo
    echo " - $module_name"
    (cd $repo && cd ../../trunk && git status -sb | grep -v '## master')
    echo " - $module_name (scripts)" 
    (cd $repo && cd ../../repository/scripts && git status -sb | grep -v '## master')
done

popd > /dev/null
