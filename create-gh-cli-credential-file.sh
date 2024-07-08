#!/bin/bash

github_user_name=$1
gitlab_user_name=$2

fpath=$(pwd)/importer_auth.yml

echo "Writing credentials to ${fpath}"

echo << EOT $fpath
- url: https://github.com
  access_token: ${$GH_TOKEN}
- url: https://gitlab.ecs.vuw.ac.nz/$gitlab_user_name"
  access_token: ${$GITLAB_TOKEN}
EOT

echo "Credentials written to ${fpath} for $(cat $fpath |grep '-url')