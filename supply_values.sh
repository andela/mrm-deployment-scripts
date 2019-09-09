#!/usr/bin/env bash

DIRECTORY="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
ROOT_DIRECTORY=$(dirname $DIRECTORY)

BOLD='\e[1m'
BLUE='\e[34m'
RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[92m'
NC='\e[0m'

init() {
    CREATED_FILES=()
    VARIABLES=()
}

info() {
    printf "\n${BOLD}${BLUE}====> $(echo $@ ) ${NC}\n"
}

warning () {
    printf "\n${BOLD}${YELLOW}====> $(echo $@ )  ${NC}\n"
}

error() {
    printf "\n${BOLD}${RED}====> $(echo $@ )  ${NC}\n"
    bash -c "exit 1"
}

success () {
    printf "\n${BOLD}${GREEN}====> $(echo $@ ) ${NC}\n"
}

# find template files
findTemplateFiles() {
    # determine the directory
    local new_dir=$([ "$2" != "" ] && echo $new_dir || echo $DIRECTORY )
    info "current directory is $new_dir"
    local _yamlFilesVariable=$1
    local _templates=$(find $new_dir -name "*.templ" -type f)
    if [ "$_yamlFilesVariable" ]; then
        # let variable parsed carry the array of templates
        eval $_yamlFilesVariable="'$_templates'"
    else
        echo $_templates;
    fi
}

# find variable and replace it within the file
findAndReplaceVariables() {
  for file in ${TEMPLATES[@]}; do
    local output=${file%.templ}
    local temp=""
    cp $file $output
    info "Building $(basename $file) template to $(basename $output)"
    for variable in ${VARIABLES[@]}; do
        local value=${!variable}
        sed -i -e "s|\$($variable)|$value|g" $output;
    done
    if [[ $? == 0 ]]; then
        success "Template file $(basename $file) has been successfuly built to $(basename $output)"
    else
        error "Failed to build template $(basename $file), variable $temp not found"
    fi
  done
  # info "Cleaning backup files after substitution" for mac
}

main(){
    local new_dir="$DIRECTORY"
    info "building $1 scripts"
    findTemplateFiles 'TEMPLATES' $new_dir
    findAndReplaceVariables
    rm values.sh
}

# set array of template variables
source variables.sh
# clean out environment prefix
touch values.sh
if [ "$CIRCLE_BRANCH" == master ]; then
    backend_version=$( gsutil cp gs://$PRODUCTION_BACKEND_IMAGE_VERSION_PATH/current_version . && cat current_version )
    export PRODUCTION_BACKEND_IMAGE=$PRODUCTION_BACKEND_IMAGE:$backend_version
    frontend_version=$( gsutil cp gs://$PRODUCTION_FRONTEND_IMAGE_VERSION_PATH/current_version . && cat current_version )
    export PRODUCTION_FRONTEND_IMAGE=$PRODUCTION_FRONTEND_IMAGE:$frontend_version
    push_service_version=$( gsutil cp gs://$PRODUCTION_MICROSERVICE_IMAGE_VERSION_PATH/current_version . && cat current_version )
    export PRODUCTION_MICROSERVICE_IMAGE=$PRODUCTION_MICROSERVICE_IMAGE:$push_service_version
    slack_service_version=$( gsutil cp gs://$PRODUCTION_SLACK_MICROSERVICE_IMAGE_VERSION_PATH . && cat working_image )
    export PRODUCTION_SLACK_MICROSERVICE_IMAGE=$PRODUCTION_SLACK_MICROSERVICE_IMAGE:$slack_service_version
    printenv | grep PRODUCTION_ | sed "s/^PRODUCTION_\(.*\)=/\L&/" | sed "s/production_//" > values.sh
elif [ "$CIRCLE_BRANCH" == develop ]; then
    backend_version=$( gsutil cp gs://$STAGING_BACKEND_IMAGE_VERSION_PATH/current_version . && cat current_version )
    export STAGING_BACKEND_IMAGE=$STAGING_BACKEND_IMAGE:$backend_version
    frontend_version=$( gsutil cp gs://$STAGING_FRONTEND_IMAGE_VERSION_PATH/current_version . && cat current_version )
    export STAGING_FRONTEND_IMAGE=$STAGING_FRONTEND_IMAGE:$frontend_version
    push_service_version=$( gsutil cp gs://$STAGING_MICROSERVICE_IMAGE_VERSION_PATH/current_version . && cat current_version )
    export STAGING_MICROSERVICE_IMAGE=$STAGING_MICROSERVICE_IMAGE:$push_service_version
    slack_service_version=$( gsutil cp gs://$STAGING_SLACK_MICROSERVICE_IMAGE_VERSION_PATH . && cat working_image )
    export STAGING_SLACK_MICROSERVICE_IMAGE=$STAGING_SLACK_MICROSERVICE_IMAGE:$slack_service_version
    printenv | grep STAGING_ | sed "s/^STAGING_\(.*\)=/\L&/" | sed "s/staging_//" > values.sh
else
    backend_version=$( gsutil cp gs://$SANDBOX_BACKEND_IMAGE_VERSION_PATH/current_version . && cat current_version )
    export SANDBOX_BACKEND_IMAGE=$SANDBOX_BACKEND_IMAGE:$backend_version
    frontend_version=$( gsutil cp gs://$SANDBOX_FRONTEND_IMAGE_VERSION_PATH/current_version . && cat current_version )
    export SANDBOX_FRONTEND_IMAGE=$SANDBOX_FRONTEND_IMAGE:$frontend_version
    push_service_version=$( gsutil cp gs://$SANDBOX_MICROSERVICE_IMAGE_VERSION_PATH/current_version . && cat current_version )
    export SANDBOX_MICROSERVICE_IMAGE=$SANDBOX_MICROSERVICE_IMAGE:$push_service_version
    slack_service_version=$( gsutil cp gs://$SANDBOX_SLACK_MICROSERVICE_IMAGE_VERSION_PATH . && cat working_image )
    export SANDBOX_SLACK_MICROSERVICE_IMAGE=$SANDBOX_SLACK_MICROSERVICE_IMAGE:$slack_service_version
    printenv | grep SANDBOX_ | sed "s/^SANDBOX_\(.*\)=/\L&/" | sed "s/sandbox_//" > values.sh
fi
# set variables and values of templates
source values.sh

main @#
