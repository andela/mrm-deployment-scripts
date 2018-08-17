#!/usr/bin/env/ bash

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

# require "variable name" "value"
require () {
    if [ -z ${2+x} ]; then error "Required variable ${1} has not been set"; fi
}

# find template files
findTemplateFiles() {
    # determine the directory
    local new_dir=$([ "$2" != "" ] && echo $new_dir || echo $DIRECTORY )
    info "current directory is $new_dir"
    local _yamlFilesVariable=$1
    local _templates=$(find $new_dir -name "*.templ" -type f)
    if [ "$_yamlFilesVariable" ]; then
        eval $_yamlFilesVariable="'$_templates'"
    else
        echo $_templates;
    fi
}

findAndReplaceVariables() {
  for file in ${TEMPLATES[@]}; do
    local output=${file%.templ}
    local temp=""
    cp $file $output
    info "Building $(basename $file) template to $(basename $output)"
    for variable in ${VARIABLES[@]}; do
        local value=${!variable}
        sed -i "s|\$$variable|$value|g" $output;
        sed -i "s|\$($variable)|$value|g" $output;
        sed -i "s|{{env \`$variable\`}}|$value|g" $output;
        sed -i "s|{{ env \`$variable\` }}|$value|g" $output;
        local extension="${output##*.}"
        if [[ $extension == "tf" ]]; then
            export temp=$variable
            sed -i -e ":x /\"$variable\" {$/ { N; s/$/\n  default = $value/g ; bx }" $output
        fi
    done
    if [[ $? == 0 ]]; then
        success "Template file $(basename $file) has been successfuly built to $(basename $output)"
    else
        error "Failed to build template $(basename $file), variable $temp not found"
    fi
  done
  # info "Cleaning backup files after substitution"
}

delete_created_files() {
    echo "${TEMPLATES}"
    for file in ${TEMPLATES[@]}; do
        local output=${file%.templ}
        info "On ${output}"
        rm $output
    done
}

create_shared_templates() {
    local new_dir="$DIRECTORY"
    eval new_dir+="/images/shared/"
    findTemplateFiles 'TEMPLATES' $new_dir
    findAndReplaceVariables
}

create_image_scripts() {
    create_shared_templates
    if [[ $1 == "backend" ]]; then
        local new_dir="$DIRECTORY"
        eval new_dir+="/images/backend-image/"
        info "Creating $1 scripts"
        findTemplateFiles 'TEMPLATES' $new_dir
        findAndReplaceVariables
        #warning "${TEMPLATES}"

    elif [[ $1 == "frontend" ]]; then
        local new_dir="$DIRECTORY"
        eval new_dir+="/images/frontend-image/"
        info "building $1 image"
        findTemplateFiles 'TEMPLATES' $new_dir
        findAndReplaceVariables

    elif [[ $1 == "elk" ]]; then
        local new_dir="$DIRECTORY"
        eval new_dir+="/images/monitoring/"
        info "building $1 image"
        findTemplateFiles 'TEMPLATES' $new_dir
        findAndReplaceVariables

    elif [[ $1 == "nat" ]]; then
        local new_dir="$DIRECTORY"
        eval new_dir+="/images/nat-image/"
        info "building $1 image"
        findTemplateFiles 'TEMPLATES' $new_dir
        findAndReplaceVariables

    elif [[ $1 == "vault" ]]; then
        local new_dir="$DIRECTORY"
        eval new_dir+="/images/vault-image/"
        info "building $1 image"
        findTemplateFiles 'TEMPLATES' $new_dir
        findAndReplaceVariables

    elif [[ $1 == "barman" ]]; then
        local new_dir="$DIRECTORY"
        eval new_dir+="/images/database-image/barman/"
        info "building $1 image"
        findTemplateFiles 'TEMPLATES' $new_dir
        findAndReplaceVariables

    elif [[ $1 == "postgres" ]]; then
        local new_dir="$DIRECTORY"
        eval new_dir+="/images/database-image/postgres/"
        info "building $1 image"
        findTemplateFiles 'TEMPLATES' $new_dir
        findAndReplaceVariables

    elif [[ $1 == "terraform" ]]; then
        local new_dir="$DIRECTORY"
        eval new_dir+="/terraform/"
        info "building $1 scripts"
        findTemplateFiles 'TEMPLATES' $new_dir
        findAndReplaceVariables

    else
        error "Error: no image name $1"
    fi

}

approve_scripts_recreation(){
$([ "$2" == "" ] && read -p "Do you want to create scripts for $1 (y/n)?" $2 )
case "$2" in 
    yes|y|Y ) warning "Recreating scripts for $1" && create_image_scripts $1 ;;
    no|n|N ) warning "Using existing scripts for $1";;
    * ) error "Error invalid option, provide (y/n)";;
esac
}

packer_action() {
    if [[ $1 == "backend" ]]; then
        local new_dir="$DIRECTORY"
        local script="backend-template.json"
        eval new_dir+="/images/backend-image/"
        info "Creating $1 scripts"
        approve_scripts_recreation $1 $3
        cd $new_dir
        info "Executing packer"
        packer $2 "$new_dir$script"
        cd $DIRECTORY

    elif [[ $1 == "frontend" ]]; then
        local new_dir="$DIRECTORY"
        local script="frontend-template.json"
        eval new_dir+="/images/frontend-image/"
        info "Creating $1 scripts"
        approve_scripts_recreation $1 $3
        cd $new_dir
        info "Executing packer"
        packer $2 "$new_dir$script"
        cd $DIRECTORY

    elif [[ $1 == "elk" ]]; then
        local new_dir="$DIRECTORY"
        local script="elk-provisioner.json"
        eval new_dir+="/images/monitoring/ELK/"
        info "Creating $1 scripts"
        approve_scripts_recreation $1 $3
        cd $new_dir
        info "Executing packer"
        packer $2 "$new_dir$script"
        cd $DIRECTORY

    elif [[ $1 == "nat" ]]; then
        local new_dir="$DIRECTORY"
        local script="nat-template.json"
        eval new_dir+="/images/nat-image/"
        info "Creating $1 scripts"
        approve_scripts_recreation $1 $3
        cd $new_dir
        info "Executing packer"
        packer $2 "$new_dir$script"
        cd $DIRECTORY

    elif [[ $1 == "vault" ]]; then
        local new_dir="$DIRECTORY"
        local script="frontend-template.json"
        eval new_dir+="/images/frontend-image/"
        info "Creating $1 scripts"
        approve_scripts_recreation $1 $3
        cd $new_dir
        info "Executing packer"
        packer $2 "$new_dir$script"
        cd $DIRECTORY

    elif [[ $1 == "barman" ]]; then
        local new_dir="$DIRECTORY"
        local script="frontend-template.json"
        eval new_dir+="/images/frontend-image/"
        info "Creating $1 scripts"
        approve_scripts_recreation $1 $3
        cd $new_dir
        info "Executing packer"
        packer $2 "$new_dir$script"
        cd $DIRECTORY

    elif [[ $1 == "postgres" ]]; then
        local new_dir="$DIRECTORY"
        local script="frontend-template.json"
        eval new_dir+="/images/frontend-image/"
        info "Creating $1 scripts"
        approve_scripts_recreation $1 $3
        cd $new_dir
        info "Executing packer"
        packer $2 "$new_dir$script"
        cd $DIRECTORY

    else
        error "Error: no image name $1"

    fi

}

create_terraform_scripts() {
    local new_dir="$DIRECTORY"
    eval new_dir+="/terraform/"
    info "Creating terraform scripts"
    findTemplateFiles 'TEMPLATES' $new_dir
    findAndReplaceVariables

}

terraform_action() {
    local new_dir="$DIRECTORY"
    eval new_dir+="/terraform/"
    info "Creating $1 scripts"
    approve_scripts_recreation $1 "${@: -1}"
    cd $new_dir
    ls -al
    info "Executing terraform"
    terraform "${@:2:${#}-2}"
    cd $DIRECTORY

}

build(){
    if [[ $2 == 'create' ]]; then
        if [[ $3 == 'image' ]]; then
            if [[ $4 == 'all' ]]; then
                local all_images=(
                'backend' 'frontend' 
                'elk' 'nat' 'vault' 
                'barman' 'postgres')
                for image in "${all_images[@]}"; do
                    create_image_scripts $image
                done
                success "All image scripts have successfully been created"
            else
                create_image_scripts $4
                success "$4 image scripts have successfully been created"
            fi
        else
            error "Unknown command $@"
        fi
    elif [[ $2 == 'packer' ]]; then
        if [[ $4 == 'all' ]]; then
            local all_images=(
            'backend' 'frontend' 
            'elk' 'nat' 'vault' 
            'barman' 'postgres')
            for image in "${all_images[@]}"; do
                packer_action $image $3 $5
            done
            success "Packer $3 for all images finished successfully"
        else
            packer_action $4 $3 $5
            success "Packer $3 $4 image finished successfully"
        fi

    elif [[ $2 == 'clean' ]]; then
        local all_images=(
        'backend' 'frontend' 
        'elk' 'nat' 'vault' 
        'barman' 'postgres')
        for image in "${all_images[@]}"; do
            create_image_scripts $image
            delete_created_files
            create_terraform_scripts
            delete_created_files
        done
    elif [[ $2 == 'terraform' ]]; then
        eval "$1_terraform_variables"
        if [[ $3 == 'extract' ]]; then 
            create_terraform_scripts
        else
            terraform_action "${@:2}"
        fi
    else
        error "Unknown command $@"
    fi
}

main() {
    init
    if [[ $1 == 'sandbox' ]]; then
        source sandbox_env.sh 
        sandbox_image_variables
        build "${@:1:${#}}"
    elif [[ $1 == 'staging' ]]; then
        source staging_env.sh 
        staging_image_variables
        build "${@:1:${#}}"
    elif [[ $1 == 'production' ]]; then
        source production_env.sh 
        production_image_variables
        build "${@:1:${#}}"
    else
        error "Please specify environment"
    fi
}

main $@
