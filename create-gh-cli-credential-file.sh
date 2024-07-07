#!/bin/bash

github_user_name=$1
gitlab_user_name=$2

echo "- url: https://github.com/$github_user_name" > importer_auth.yml
echo -e "\t\tacces_token:\t$GH_TOKEN" >> importer_auth.yml
echo "- url: https://gitlab.ecs.vuw.ac.nz/$gitlab_user_name" > importer_auth.yml
echo -e "\t\tacces_token:\t$GITLAB_TOKEN" >> importer_auth.yml
echo -e "\t\tprovider:\tgitlab"