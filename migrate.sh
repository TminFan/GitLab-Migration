#!/bin/bash

github_repo_name=$1
github_user_name=$2
gitlab_repo_name=$3
gitlab_user_name=$4


if [[ -n $GH_TOKEN && -n $GITLAB_ACCESS_TOKEN ]]; then
    git ls-remote --heads --exit-code https://$github_user_name:$GH_TOKEN@github.com/"$github_user_name"/"$github_repo_name".git >/dev/null
    echo "Does the GitHub repo $github_repo_name exist already? exit code is $?"
    if [ "$?" > "0" ]
    then
        gh repo create "$github_repo_name" --private --source .
    fi
    git clone --bare https://"$gitlab_user_name":"$GITLAB_ACCESS_TOKEN"@"$gitlab_repo_name"
    git push --mirror https://$github_user_name:$GH_TOKEN@github.com/"$github_user_name"/"$github_repo_name".git
else
    echo "EROOR: Tokens are not set in the environment variables."
    exit 1
fi