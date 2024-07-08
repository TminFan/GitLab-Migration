#!/bin/bash

gitlab_namespace=$1
github_base_url="https://github.com"
gitlab_base_url="https://gitlab.ecs.vuw.ac.nz"

gh actions-importer audit gitlab --gitlab-instance-url $gitlab_base_url --gitlab--access-token $GITLAB_TOKEN --github-instance-url $github_base_url --github-access-token $GH_TOKEN --output-dir tmp/audit --namespace $gitlab_namespace

ls tmp/audit/

content=$(<tmp/audit/audit_summary.md)
content="${content//'%'/'%25'}"
content="${content//$'\n'/'%0A'}"
content="${content//$'\r'/'%0D'}"

curl \
-X POST \
-H "Accept: application/vnd.github.v3+json" \
-H "Authorization: token $GH_TOKEN" \
"https://api.github.com/repos/${{ github.repository }}/check-runs" \
-d "$(jq -n \
      --arg name "Markdown Summary Check" \
      --arg head_sha "${{ github.sha }}" \
      --arg title "Check Run Report" \
      --arg summary "$content" \
      --arg text "More details here" \
      '{
        name: $name,
        head_sha: $head_sha,
        status: "completed",
        conclusion: "success",
        output: {
          title: $title,
          summary: $summary,
          text: $text
        }
      }')"