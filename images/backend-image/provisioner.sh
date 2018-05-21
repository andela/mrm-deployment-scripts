#/bin/bash

function setup_vault {
  echo "---Installing Vault---"

  sudo apt-get install jq unzip -y
  sudo curl https://releases.hashicorp.com/vault/0.10.1/vault_0.10.1_linux_amd64.zip -o vault.zip
  unzip vault.zip
  sudo mv vault /usr/local/bin/vault
}
function install_dependencies {
  echo "---installing dependencies---"
  sudo apt-get update
  sudo apt-get -y upgrade
  sudo apt-get install python3.6 -y
  sudo apt-get install -y python-pip
  sudo apt-get install supervisor -y && sudo supervisord
  echo "---Upgrading pip---"

  sudo pip install --upgrade pip
  sudo pip install virtualenvwrapper

}

function move_startup_script {
  sudo mv /tmp/startup-script.sh $HOME/startup-script.sh
}
function move_supervisor_script {
  sudo mv /tmp/mrm_api.conf /etc/supervisor/conf.d/mrm_api.conf
}
function main {
  install_dependencies
  move_startup_script
  move_supervisor_script
  setup_vault
}
main
