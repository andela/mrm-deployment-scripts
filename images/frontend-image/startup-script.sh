#!/usr/bin/env bash

function get_instance_metadata {
  local name="$1"

  curl -s -H "Metadata-Flavor: Google" \
    "http://metadata.google.internal/computeMetadata/v1/instance/attributes/${name}"
}

function store_instance_variables {
  echo "---Retrieving env variables---"
  cd ~/mrm_front
  echo "APP_SETTINGS=\"$(get_instance_metadata "APP_SETTINGS")\"" >> .env
    if [[ $(get_instance_metadata "environment") == "production" ]]; then
        echo "MRM_URL=\"$(get_instance_metadata "MRM_URL_PRODUCTION")\"" >> .env
        echo "MRM_API_URL=\"$(get_instance_metadata "MRM_API_URL_PRODUCTION")\"" >> .env
    elif [[ $(get_instance_metadata "environment") == "staging" ]]; then
        echo "MRM_URL=\"$(get_instance_metadata "MRM_URL_STAGING")\"" >> .env
        echo "MRM_API_URL=\"$(get_instance_metadata "MRM_API_URL_STAGING")\"" >> .env
    elif [[ $(get_instance_metadata "environment") == "sandbox" ]]; then
        echo "MRM_URL=\"$(get_instance_metadata "MRM_URL_SANDBOX")\"" >> .env
        echo "MRM_API_URL=\"$(get_instance_metadata "MRM_API_URL_SANDBOX")\"" >> .env
    fi
  echo "ANDELA_LOGIN_URL=\"$(get_instance_metadata "ANDELA_LOGIN_URL")\"" >> .env
  echo "ANDELA_API_URL=\"$(get_instance_metadata "ANDELA_API_URL")\"" >> .env
  
  echo "FIREBASE_API_KEY=\"$(get_instance_metadata "FIREBASE_API_KEY")\"" >> .env
  echo "FIREBASE_PROJECT_ID=\"$(get_instance_metadata "FIREBASE_PROJECT_ID")\"" >> .env
  echo "FIREBASE_DATABASE_NAME=\"$(get_instance_metadata "FIREBASE_DATABASE_NAME")\"" >> .env
  echo "FIREBASE_BUCKET=\"$(get_instance_metadata "FIREBASE_BUCKET")\"" >> .env
  cd ..
}

function clone_repo {
echo "---cloning repo---"
  sudo chown -R packer /home/packer/.config
  n=0
  EXIT_CODE=1
  until [ $n -ge 4 ]
  do
    [[ -d mrm_front ]] && EXIT_CODE=0 && break
    git clone git@github.com:andela/mrm_front.git
    if [ $? -eq 128 ]; then
      EXIT_CODE=128
      echo "Unable to clone Repo (Permission Denied)"
      break
    fi

    n=$[$n+1]
    sleep 15
  done
  [[ ! -d mrm_front ]] && $(exit-on-failure) && break
  echo ">>>Cloning Successful---"
  . ~/.nvm/nvm.sh
}
function install_dependencies {
  echo "---Installing dependencies---"

  nvm use node
  cd mrm_front
  yarn
  cd ..
}
function build_project {
  echo "---Installing dependencies---"
  npm install webpack -g --unsafe-perm
  cd mrm_front
  yarn build

  cd ..
}
function get_vault_address {
  echo $(get_instance_metadata "mrm_vault_server_IP")
}
function login_vault {
    if [[ $(get_instance_metadata "environment") == "production" ]]; then
        vault_token=$(curl http://metadata.google.internal/computeMetadata/v1/project/attributes/production_mrm_vault_auth_token -H "Metadata-Flavor: Google")
    elif [[ $(get_instance_metadata "environment") == "staging" ]]; then
        vault_token=$(curl http://metadata.google.internal/computeMetadata/v1/project/attributes/staging_mrm_vault_auth_token -H "Metadata-Flavor: Google")
    elif [[ $(get_instance_metadata "environment") == "sandbox" ]]; then
        vault_token=$(curl http://metadata.google.internal/computeMetadata/v1/project/attributes/sandbox_mrm_vault_auth_token -H "Metadata-Flavor: Google")
    fi
  export VAULT_ADDR="http://$(get_vault_address):8200"

  echo "---Authenticating on Vault Server---"

  vault login ${vault_token}
}
function retrieve_repo_key {
   if [ ! -d $HOME/.ssh ]; then
    echo "---creating ssh directory---"
    sudo mkdir -p $HOME/.ssh
    sudo chmod 700 $HOME/.ssh
    echo "Directory Created>>>"
  fi
  echo "---Downloading Repo Key from Vault Server---"
  vault read -format="json" mrm/keys | jq -r .data.mrm_repo_private_key > $HOME/.ssh/id_rsa
  if [ ! "$(ssh-keygen -F github.com)" ]; then
    ssh-keyscan github.com >> $HOME/.ssh/known_hosts
  fi
  #Change permissions on key file to read only
  chmod 600 $HOME/.ssh/id_rsa

}
function start_services {
    echo "---setting up Beats---"

    sudo filebeat setup --template -E output.logstash.enabled=false -E "output.elasticsearch.hosts=["mrm-sandbox-elk-server:9200"]"
  sudo metricbeat setup
    echo "---Starting metricbeat---"
  sudo service metricbeat start
    echo "---Starting filebeat---"
  sudo service filebeat start
    echo "---reStarting NGINX---"
  sudo systemctl restart nginx
}

function exit-on-failure {
  sudo bash /home/packer/slack.sh "Failure" ${HOSTNAME} ${EXIT_CODE}
  exit $EXIT_CODE
}
function successful-startup {
  sudo bash /home/packer/slack.sh "Success" ${HOSTNAME}
}

function main {
  export NODE_ENV=production
  login_vault
  retrieve_repo_key
  clone_repo
  install_dependencies
  store_instance_variables
  build_project
  start_services
  successful-startup
}
export HOSTNAME=mrm-sandbox-frontend-instance
main "$@"
