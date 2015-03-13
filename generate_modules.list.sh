#!/bin/bash
path_to_devtools="$(dirname "$0")"
find $path_to_devtools/../modules -type d -name '.git' | grep -v 'repository/scripts/\.git$' | sed 's/\/trunk\/\.git$//g' | sed 's/.*\///g' > $path_to_devtools/modules.list
