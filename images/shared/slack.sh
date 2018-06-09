#!/usr/bin/env bash
function get-HOOK_URL {
  echo $(curl http://metadata.google.internal/computeMetadata/v1/project/attributes/SLACK_WEBHOOK_URl -H "Metadata-Flavor: Google")
}
function timestamp {
  echo $(date +%s)
}

function get-payload {
  SERVER_NAME="$2"

  EXIT_CODE="$3"
  FALLBACK="Your deployment to ${SERVER_NAME} Failed With ${EXIT_CODE}"
  COLOR="#ff1111"
  PRIORITY="High"
  IMG_URL="https://github.com/andela/mrm-deployment-scripts/docs/images/compute-engine-failure.png"
  PRETEXT="This Deployment to ${SERVER_NAME} Did not start up Successfully Exit Code: ${EXIT_CODE}"
  TXT="Instance ${SERVER_NAME} is Unfortunately Down :("
  if [[ "$1" == "Success" ]]; then
    PRETEXT="This Deployment to ${SERVER_NAME} Started up Successfully"
    FALLBACK="Your deployment to ${SERVER_NAME} Was Successful"
    COLOR="#36a64f"
    PRIORITY="Low"
    TXT="Instance ${SERVER_NAME} is Now UP :D"

    IMG_URL="https://github.com/andela/mrm-deployment-scripts/docs/images/compute-engine-success.png"
  fi

  echo "{\"attachments\": [{ \
    \"fallback\": \"${FALLBACK}\", \
    \"color\": \"${COLOR}\", \
    \"pretext\": \"${PRETEXT}\", \
    \"author_name\": \"Converge Devops\", \
    \"author_icon\": \"https://slack-files2.s3-us-west-2.amazonaws.com/avatars/2018-06-07/377306313699_e8b32b254dd600d70afa_192.png\", \
    \"title\": \"${TXT}\", \
    \"text\": \"Instance \", \
    \"fields\": [{ \
            \"title\": \"Priority\", \
            \"value\": \"${PRIORITY}\", \
            \"short\": false }], \
    \"image_url\": \"${IMG_URL}\", \
    \"thumb_url\": \"${IMG_URL}\", \
    \"footer\": \"Converge Deployment\", \
    \"footer_icon\": \"https://slack-files2.s3-us-west-2.amazonaws.com/avatars/2018-06-07/377306313699_e8b32b254dd600d70afa_192.png\", \
    \"ts\": $(timestamp)}]}"
}
function send_Notif {
  curl -X POST -H 'Content-type: application/json' --data "$(get-payload $1 $2 $3)" $(get-HOOK_URL)
}
function main {
  send_Notif $1 $2 $3
}
main $1 $2 $3
