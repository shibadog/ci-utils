create_story_payload() {
  name="$1 upgrade $2"
  description="This is an auto generated story created for $1 upgrade to $2"
  echo '{"name":"'"$name"'","description":"'"$description"'"}'
}

generate_pivtal_tracker_story() {
  local component=$1
  local tag=$2

  # See https://www.pivotaltracker.com/help/api/rest/v5#Stories
  token=${PIVOTAL_TRACKER_TOKEN}
  project_id=${PIVOTAL_TRACKER_PROJECT_ID}
  payload=$(create_story_payload $component $tag)
  curl -X POST -H "X-TrackerToken: ${token}" -H "Content-Type: application/json" -d "$payload" "https://www.pivotaltracker.com/services/v5/projects/${project_id}/stories"
}