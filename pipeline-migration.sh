#!/bin/bash

audit=$1
github_user_name=$2
github_repo_name=$3
gitlab_user_name=$4
gitlab_repo_name=$5
# github_base_url="https://github.com/$github_user_name/"
# gitlab_base_url="https://gitlab.ecs.vuw.ac.nz"

echo $audit

gh extension install github/gh-actions-importer

# verify the actions importer extension is installed
gh actions-importer version

# configure credentials
if [[ -n $GH_TOKEN && -n $GITLAB_TOKEN ]]; then
    ./create-gh-cli-credentials-file.sh $github_user_name $gitlab_user_name
    gh actions-importer configure --credentials-file importer_auth.yml
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
    echo "Start migrating pipelines"
    gh actions-importer migrate gitlab --target-url "https://$github_user_name:$GH_TOKEN@github.com/$github_user_name/$github_repo_name" --output-dir tmp/migrate --namespace $gitlab_user_name --project $gitlab_repo_name
fi

rm importer_auth.yml