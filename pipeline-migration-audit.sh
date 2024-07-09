#!/bin/bash

gitlab_namespace=$1
github_base_url="https://github.com"
gitlab_base_url=$2

# Audit project pipelines of the given GitLab group
gh actions-importer audit gitlab --gitlab-instance-url $gitlab_base_url --gitlab-access-token $GITLAB_TOKEN --github-instance-url $github_base_url --github-access-token $GH_TOKEN --output-dir tmp/audit --namespace $gitlab_namespace

# Output audit summary to workflow job summary
if [[ -f tmp/audit/audit_summary.md ]]; then
  echo "Migration audit report is found."
  content=$(cat tmp/audit/audit_summary.md)
  echo "$content" >> $GITHUB_STEP_SUMMARY
else
  echo "Migration audit report is not found."
  exit 1
fi