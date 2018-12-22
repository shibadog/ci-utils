create_issue_payload() {
  title="$1 upgrade $2"
  body="This is an auto generated issue created for $1 upgrade to $2"
  echo '{"title":"'"$title"'","body":"'"$body"'"}'
}

generate_gh_issue() {
  local user=$1
  local component=$2
  local tag=$3
  local repo=$4

  # See https://developer.github.com/v3/issues/#create-an-issue
  token=${GITHUB_API_TOKEN}
  payload=$(create_issue_payload "$component" "$tag")
  curl -u ${user}:${GITHUB_API_TOKEN} -H "Content-Type: application/json" -X POST -d "$payload" https://api.github.com/repos/${repo}/issues
}