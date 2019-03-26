# https://github.com/cloudfoundry-incubator/kubo-ci/blob/master/scripts/lib/generate-pr.sh

create_pr_payload() {
  title="$1 upgrade $2"
  body="This is an auto generated PR created for $1 upgrade to $2"
  echo '{"title":"'"$title"'","body":"'"$body"'","head":"'"$3"'","base":"'"$4"'"}'
}

# Needs to be called from the directory where PR needs to be generated
generate_pull_request() {
  local user=$1
  local component=$2
  local tag=$3
  local repo=$4
  local base=$5

  mkdir -p ~/.ssh
  cat > ~/.ssh/config <<EOF
StrictHostKeyChecking no
LogLevel quiet
EOF
  chmod 0600 ~/.ssh/config

  cat > ~/.ssh/id_rsa <<EOF
${GIT_SSH_KEY}
EOF
  chmod 0600 ~/.ssh/id_rsa
  eval $(ssh-agent) >/dev/null 2>&1
  trap "kill $SSH_AGENT_PID" 0
  ssh-add ~/.ssh/id_rsa

  git config --global user.email "${GIT_EMAIL}"
  git config --global user.name "${GIT_NAME}"

  branch_name="upgrade/${component}${tag}"
  git checkout -b $branch_name
  git add .
  git commit -m "Upgrade $component to $tag"
  git push origin $branch_name

  # create a PR here
  token=${GITHUB_API_TOKEN}
  payload=$(create_pr_payload "$component" "$tag" "$branch_name" "$base")
  curl -u ${user}:${GITHUB_API_TOKEN} -H "Content-Type: application/json" -X POST -d "$payload" https://${GITHUB_API_ENDPOINT}/repos/${repo}/pulls
}
