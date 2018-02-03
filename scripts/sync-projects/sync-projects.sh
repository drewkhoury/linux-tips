#!/usr/bin/env bash

# source: https://gist.github.com/JonasGroeger/1b5155e461036b557d0fb4b3307e1e75
# modified by Andrew Khoury (drew.khouey@gmail.com)

# Documentation
# https://docs.gitlab.com/ce/api/projects.html#list-projects

echo "-------------------------------------------------------------------------"
echo "Requirements: git, jq, token for your user on gitlab"
echo "(most of which could be wrapped in a docker container!)"
echo "-------------------------------------------------------------------------"
echo ""

if [ "$#" -ne 2 ]; then
    echo 'If your repo looks like this: `git@gitlab.com:foo/bar.git` ... try `./sync-projects.sh foo /path/to/base/folder`.'
    echo '$1 should be group/namespace where source repos live.'
    echo '$2 should be the destination folder where the repos should be cloned to.'
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
NAMESPACE="${1}"
REPO_BASE_DIR="${2}"

# vars you need to confirm/change
BASE_PATH="https://gitlab.com/"

# env var that you need
if [ -z "$GITLAB_PRIVATE_TOKEN" ]; then
    echo 'Please set the environment variable `export GITLAB_PRIVATE_TOKEN=foo`'
    echo "See ${BASE_PATH}profile/account"
    exit 1
fi

# vars you shouldn't need to change
PROJECT_SEARCH_PARAM=""
PROJECT_SELECTION="select(.namespace.name == \"$NAMESPACE\")"
PROJECT_PROJECTION="{ "path": .path, "git": .ssh_url_to_repo }"
FILENAME="repos.json"

trap "{ rm -f $FILENAME; }" EXIT

echo "-------------------------------------------------------------------------"
echo "${BASE_PATH}api/v3/projects?private_token=XXX&search=$PROJECT_SEARCH_PARAM&per_page=999 > $FILENAME"
echo ""

curl -s "${BASE_PATH}api/v3/projects?private_token=$GITLAB_PRIVATE_TOKEN&search=$PROJECT_SEARCH_PARAM&per_page=999" \
    | jq --raw-output --compact-output ".[] | $PROJECT_SELECTION | $PROJECT_PROJECTION" > "$FILENAME"

while read repo; do
    THEPATH=$(echo "$repo" | jq -r ".path")
    FULLPATH=${REPO_BASE_DIR}/${THEPATH}
    GIT=$(echo "$repo" | jq -r ".git")

    if [ ! -d "$FULLPATH" ]; then
        echo "Cloning $FULLPATH ( $GIT )"
        git clone ${GIT} ${FULLPATH} &
    else
        echo "Pulling ${FULLPATH}"
        (cd "${FULLPATH}" && git pull) &
    fi
done < "$FILENAME"

echo ""
echo "Ready to run the commands ..."
echo ""
wait
