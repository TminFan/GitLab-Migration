#!/bin/bash

gitlab_namespace=$1
github_user_name=$2
github_repo_name=
github_base_url="https://github.com"
gitlab_base_url="https://gitlab.ecs.vuw.ac.nz"

gh actions-importer audit gitlab --gitlab-instance-url $gitlab_base_url --gitlab-access-token $GITLAB_TOKEN --github-instance-url $github_base_url --github-access-token $GH_TOKEN --output-dir tmp/audit --namespace $gitlab_namespace

ls tmp/audit/
if [[ -f tmp/audit/audit_summary.md ]]; then
  echo "Migration audit report is found."
  content=$(<tmp/audit/audit_summary.md)
  echo "AUDIT_SUMMARY=$content" >> $GITHUB_ENV
else
  echo "Migration audit report is not found."
  exit 1
fi