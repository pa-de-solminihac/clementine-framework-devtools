#!/usr/bin/env bash
path_to_devtools="$(dirname "$0")"
pushd $path_to_devtools > /dev/null

g=`ls -d ../modules/*/trunk/.git`
for repo in ${g[@]}
do
    module_name="$(echo "$repo" | cut -d "/" -f 3)"
    echo
    echo "=========================="
    echo "Log du module $module_name"
    echo "=========================="
    echo
    (cd $repo && cd ../../trunk && git log | grep -v '## master')
done

popd > /dev/null
