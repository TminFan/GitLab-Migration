#!/bin/bash

github_user_name=$1
github_repo_name=$2
gitlab_user_name=$3
gitlab_repo_full_path=$4


if [[ -n $GH_TOKEN && -n $GITLAB_TOKEN ]]; then
    # Check if a GitHub repo with the given repo name has already existed
    git ls-remote --heads --exit-code https://$github_user_name:$GH_TOKEN@github.com/"$github_user_name"/"$github_repo_name".git >/dev/null
    echo "Does the GitHub repo $github_repo_name exist already? exit code is $?"
    if [ "$?" > "0" ]
    then
        # Create a new GitHub repo if not existing yet
        gh repo create "$github_repo_name" --private --source .
    fi
    # Clone the GitLab repo and migrate to the GitHub repo
    git clone --bare https://"$gitlab_user_name":"$GITLAB_TOKEN"@"$gitlab_repo_full_path.git"
    ls
    cd $gitlab_repo_name.git
    git push --mirror https://$github_user_name:$GH_TOKEN@github.com/"$github_user_name"/"$github_repo_name".git
else
    echo "EROOR: Tokens are not set in the environment variables."
    exit 1
fi