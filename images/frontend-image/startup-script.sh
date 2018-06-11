#!/usr/bin/env bash

function clone_repo {
echo "---cloning repo---"
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
  echo $(curl http://metadata.google.internal/computeMetadata/v1/project/attributes/mrm_vault_server_IP -H "Metadata-Flavor: Google")
}
function login_vault {
  vault_token=$(curl http://metadata.google.internal/computeMetadata/v1/project/attributes/mrm_vault_auth_token -H "Metadata-Flavor: Google")
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

  sudo filebeat setup --template -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["mrm-elk-server:9200"]'
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
  build_project
  start_services
  successful-startup
}
export HOSTNAME="mrm-frontend-instance"
main "$@"