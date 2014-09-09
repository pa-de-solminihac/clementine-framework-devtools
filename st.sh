#!/usr/bin/env bash
path_to_devtools="$(dirname "$0")"
pushd $path_to_devtools > /dev/null
echo "Status DEVTOOLS"
(git status -sb | grep -v '## master')

echo
echo "Status GIT-HOOKS"
(cd ../git-hooks && git status -sb | grep -v '## master')

echo
echo "Status INSTALLER"
(cd ../www/install && git status -sb | grep -v '## master')

echo
echo "Status WWW"
(cd ../www/trunk && git status -sb | grep -v '## master')

echo
echo "Status modules"
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
