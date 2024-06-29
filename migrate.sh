#!/bin/bash -e

github_repo_name=$1
gitlab_repo_name=$2
gitlab_user_name=$3

if [[ -n $GH_TOKEN && -n $GITLAB_ACCESS_TOKEN ]]; then
    gh repo create "$github_repo_name" --private --source .
    git clone -bare https://"$gitlab_user_name":"$GITLAB_ACCESS_TOKEN"@"$gitlab_repo_name"
    git push -mirror "$github_repo_name"
else
    echo "EROOR: Tokens are not set in the environment variables."
    exit 1
fi