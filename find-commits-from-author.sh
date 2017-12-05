#!/usr/bin/env bash

# Andrew Khoury (drew.khouey@gmail.com)

echo "-------------------------------------------------------------------------"
echo "Requirements: git"
echo "-------------------------------------------------------------------------"
echo ""

if [ "$#" -ne 2 ]; then
    echo '`./find-commits-from-author <partial_match_name_of_author> /path/to/base/folder`.'
    echo
    echo '$1 should be a partial match of the git author name, e.g kho for Andrew Khoury.'
    echo '$2 should be the destination folder where multiple git repos live as sub folders of the base folder.'
    echo
    exit 1
fi

if [ -z "$1" ]
  then
    echo '$1 should not be empty'
    exit 1
fi

if [ -z "$2" ]
  then
    echo '$2 should not be empty.'
    exit 1
fi

# vars you need to pass
AUTHOR="${1}"
REPO_BASE_DIR="${2}"


for d in ${REPO_BASE_DIR}/*; do
  if [ -d "$d" ]; then
    cd "$d"
    echo
    echo ">>> $d"
    git --no-pager log --pretty=format:"%h%x09 %an %ai %s"  --author=${AUTHOR}
    echo
  fi
done

