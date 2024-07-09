#!/bin/bash

audit=$1
github_user_name=$2
github_repo_name=$3
gitlab_user_name=$4
gitlab_repo_name=$5
github_base_url="https://github.com"
gitlab_base_url=$6

gh extension install github/gh-actions-importer

# verify the actions importer extension is installed
version_command="gh actions-importer version"
if ! $version_command &> /dev/null; then
    echo "<$version_command> could not be found"
    exit 1
else
    gh actions-importer version
fi

# Update actions-importer
gh actions-importer update

# Audit GitLab group pipeline or Migrate given GitLab project pipelines
if [[ -n $GH_TOKEN && -n $GITLAB_TOKEN ]]; then
    if [[ "$audit" == "true" ]]; then
        if [[ -x ./pipeline-migration-audit.sh ]]; then
            echo "script is executable."
        else
            chmod +x ./pipeline-migration-audit.sh
        fi
        echo "Start pipeline migration audit"
        ./pipeline-migration-audit.sh $gitlab_user_name $gitlab_base_url
    else
        echo "Start migrating pipelines"
        gh actions-importer migrate gitlab --gitlab-instance-url $gitlab_base_url --gitlab-access-token $GITLAB_TOKEN --github-instance-url $github_base_url --github-access-token $GH_TOKEN --target-url https://github.com/$github_user_name/$github_repo_name --output-dir tmp/migrate --namespace $gitlab_user_name --project $gitlab_repo_name
    fi
else
    echo "ERROR: Tokens are not set in the environment variables."
    exit 1
fi