#!/bin/bash

github_user_name=$1
github_repo_name=$2
gitlab_user_name=$3
gitlab_repo_full_path=$4
github_org=$5

fqdn_raw=$gitlab_repo_full_path
fqdn="${fqdn_raw#https://}"
fqdn="${fqdn#http://}"
gitlab_repo_full_path=$fqdn

echo "$gitlab_repo_full_path"

if [[ -n $GH_TOKEN && -n $GITLAB_TOKEN ]]; then
    # Check if a GitHub repo with the given repo name has already existed
    git ls-remote --heads --exit-code https://$github_user_name:$GH_TOKEN@github.com/"$github_user_name"/"$github_repo_name".git >/dev/null
    echo "Does the GitHub repo $github_repo_name exist already? exit code is $?"
    if [ "$?" > "0" ]
    then
        # Create a repostory in the given GitHub organization
        if [ "$github_org" = true ]; then
            echo "create repo in organization"
            gh api \
            --method POST \
            -H "Accept: application/vnd.github+json" \
            -H "X-GitHub-Api-Version: 2022-11-28" \
            /orgs/"$github_user_name"/repos \
            -f "name=$github_repo_name" -f "description=This is your first repository" -f "homepage=https://github.com" -F "private=true" -F "has_issues=true" -F "has_projects=true" -F "has_wiki=true"
        else
            # Create a new repository in the given GitHub user account if not existing yet
            gh repo create "$github_repo_name" --private --source .
        fi
    fi
    # Clone the GitLab repo and migrate to the GitHub repo
    git clone --bare https://"$gitlab_user_name":"$GITLAB_TOKEN"@"$gitlab_repo_full_path".git
    gitlab_project_name="${gitlab_repo_full_path##*/}"
    cd $gitlab_project_name.git
    git push --mirror https://"$github_user_name":"$GH_TOKEN"@github.com/"$github_user_name"/"$github_repo_name".git
else
    echo "EROOR: Tokens are not set in the environment variables."
    exit 1
fi