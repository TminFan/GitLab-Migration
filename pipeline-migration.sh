#!/bin/bash

audit=$1
github_user_name=$2
github_repo_name=$3
gitlab_user_name=$4
gitlab_repo_name=$5
github_base_url="https://github.com"
gitlab_base_url="https://gitlab.ecs.vuw.ac.nz"

echo $audit

gh extension install github/gh-actions-importer

# verify the actions importer extension is installed
gh actions-importer version
gh actions-importer update

# configure credentials
if [[ -n $GH_TOKEN && -n $GITLAB_TOKEN ]]; then
    if [[ "$audit" == "true" ]]; then
        chmod +x ./pipeline-migration-audit.sh
        echo "Start pipeline migration audit"
        ./pipeline-migration-audit.sh $gitlab_repo_name
    else
        echo "Start migrating pipelines"
        gh actions-importer migrate gitlab --gitlab-instance-url $gitlab_base_url --gitlab-access-token $GITLAB_TOKEN --github-instance-url $github_base_url --github-access-token $GH_TOKEN --target-url https://github.com/$github_user_name/$github_repo_name --output-dir tmp/migrate --namespace $gitlab_user_name --project $gitlab_repo_name
    fi
else
    echo "ERROR: Tokens are not set in the environment variables."
    exit 1
fi