#!/usr/bin/env bash

# source: https://gist.github.com/JonasGroeger/1b5155e461036b557d0fb4b3307e1e75
# modified by Andrew Khoury (drew.khouey@gmail.com)

# Documentation
# https://docs.gitlab.com/ce/api/projects.html#list-projects

echo "-------------------------------------------------------------------------"
echo "Requirements: git"
echo "-------------------------------------------------------------------------"
echo ""

if [ ! -d "/tmp/semver-tool" ]; then
  git clone https://github.com/fsaintjacques/semver-tool.git /tmp/semver-tool
fi

if [ "$#" -ne 1 ]; then
    echo 'try `./switch-branch.sh /path/to/base/folder`.'
    echo '$1 should be the destination folder where repos live.'
    exit 1
fi

if [ -z "$1" ]
  then
    echo '$1 should not be empty'
    exit 1
fi

# vars you need to pass
REPO_BASE_DIR="${1}"

# logic :: is A higher than B (1=yes it is)
# /tmp/semver-tool/src/semver compare 2.0.0 1.0.0
# 1

echo "-------------------------------------------------------------------------"
echo "Given a base directory, will look for git repos as sub-dirs."
echo "For each repo, will check if on master, and switch to the latest branch,"
echo "based on a consistant semver branching structure."
echo ""
echo "e.g look for branch v6.2.1 where that is the highest semver number of all"
echo "the remote branches."
echo "-------------------------------------------------------------------------"
echo ""

for d in ${1}/* ; do

    cd ${d}

    # Get the name of the current Git branch
    branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

    # Only push this update to the server if the current branch is the Master branch
    if [ "$branch" == "master" ]
    then
      echo ">>> (${branch}) ${d}"

      #echo
      echo "`git branch -a | grep remotes | grep -v HEAD | grep -v master`"
      #echo

      previous_branch=0.0.0
      winning_branch=0.0.0
      winning_branch_real=-0.0.0
      for remote_branch in `git branch -a | grep remotes | grep -v HEAD | grep -v master `; do
        #echo "`echo ${remote_branch#'remotes/origin/v'}`"
        #  echo "`echo ${remote_branch#'remotes/origin/v'} | cut -f1 -d'-' `"


        remote_branch_clean=${remote_branch#'remotes/origin/v'}
        #echo "${remote_branch_clean}"

        # any branches with a dash are probably feature branches that we don't want
        substring='-'
        if [ "${remote_branch_clean/$substring}" = "$remote_branch_clean" ] ; then

          #echo "${remote_branch_clean}"

          # .x isn't valid semver, so lets replace with .0 for the semver check
          if [[ "${remote_branch_clean}" == *.x ]]; then
            remote_branch_clean_altered="${remote_branch_clean/.x/.0}"

            # compare current to previous to see who wins
            #echo "     [compare] ${remote_branch_clean_altered} ${previous_branch}"
            if [[ $(/tmp/semver-tool/src/semver compare ${remote_branch_clean_altered} ${previous_branch}) == 1 ]] ; then
              #echo "     [compare-win] ${remote_branch_clean_altered} ${previous_branch}"
              winning_branch=${remote_branch_clean_altered}
              winning_branch_real=${remote_branch_clean}
            fi
            previous_branch=${remote_branch_clean_altered}
            previous_branch_real=${remote_branch_clean}

          else

            # compare current to previous to see who wins
            #echo "     [compare] ${remote_branch_clean_altered} ${previous_branch}"
            if [[ $(/tmp/semver-tool/src/semver compare ${remote_branch_clean} ${previous_branch}) == 1 ]] ; then
              #echo "     [compare-win] ${remote_branch_clean_altered} ${previous_branch}"
              winning_branch=${remote_branch_clean}
              winning_branch_real=${remote_branch_clean}
            fi
            previous_branch=${remote_branch_clean}
            previous_branch_real=${remote_branch_clean}

          fi

        else
          echo "[$remote_branch_clean] >>> bad branch name, excluded from search"
        fi

      done
      echo ""


      if [[ "${winning_branch_real}" != -0.0.0 ]]; then
        echo "[SWITCHING BRANCH] BRANCH=${winning_branch_real}"
        echo "git checkout -b v${winning_branch_real} origin/v${winning_branch_real} && git fetch"
        git checkout -b v${winning_branch_real} origin/v${winning_branch_real} && git fetch

        echo ""
      fi

    else
      echo "*** (${branch}) ${d}"
      #echo "[skipping] you are not on master branch. may the force be with you."
      echo ""
    fi

done
