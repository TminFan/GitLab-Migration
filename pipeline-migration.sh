#!/bin/bash

audit=$1
github_user_name=$2
github_repo_name=$3
gitlab_user_name=$4
gitlab_repo_name=$5
github_base_url=https://github.com
gitlab_base_url=https://gitlab.ecs.vuw.ac.nz

gh extension install github/gh-actions-importer

# verify the actions importer extension is installed
gh actions-importer -h

# configure credentials
if [[ -n $GH_TOKEN && -n $GITLAB_TOKEN ]]; then
    echo -e "GitLab\n$GH_TOKEN\n$github_base_url\n$GITLAB_TOKEN\n$gitlab_base_url" | gh actions-importer configure
    gh actions-importer update
    echo "Finished config github actions importer and update"
else
    echo "EROOR: Tokens are not set in the environment variables."
    exit 1
fi

# audit 
if [[ "$audit" == "true" ]]; then
    echo "Start pipeline migration audit"
    ./pipeline-migration-audit.sh $gitlab_repo_name
else
    gh actions-importer migrate gitlab --target-url "https://github.com/$github_user_name/$github_repo_name" --output-dir tmp/migrate --namespace $gitlab_user_name --project $gitlab_repo_name
fi