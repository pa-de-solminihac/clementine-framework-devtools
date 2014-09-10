#!/usr/bin/env bash
path_to_devtools="$(dirname "$0")"
pushd $path_to_devtools > /dev/null
echo "Status DEVTOOLS"
(git -c color.ui=always status -sb | grep -v '## ')

echo
echo "Status GIT-HOOKS"
(cd ../git-hooks && git -c color.ui=always status -sb | grep -v '## ')

echo
echo "Status INSTALLER"
(cd ../www/install && git -c color.ui=always status -sb | grep -v '## ')

echo
echo "Status WWW"
(cd ../www/trunk && git -c color.ui=always status -sb | grep -v '## ')

echo
echo "Status modules"
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
