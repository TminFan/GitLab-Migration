#!/bin/bash

gitlab_namespace=$1
curr_repo_name=${{ github.repository }}

gh actions-importer audit gitlab --output-dir tmp/audit --namespace $gitlab_namespace

content=$(<tmp/audit/audit_summary.md)
content="${content//'%'/'%25'}"
content="${content//$'\n'/'%0A'}"
content="${content//$'\r'/'%0D'}"

curl \
-X POST \
-H "Accept: application/vnd.github.v3+json" \
-H "Authorization: token $GH_TOKEN" \
"https://api.github.com/repos/$curr_repo_name/check-runs" \
-d '{
  "name": "Markdown Summary Check",
  "head_sha": '${{ github.sha }}',
  "status": "completed",
  "conclusion": "success",
  "output": {
    "title": "Check Run Report",
    "summary": '$content',
    "text": "More details here"
  }
}'