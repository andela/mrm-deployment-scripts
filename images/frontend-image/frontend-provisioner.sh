#!/usr/bin/env bash

function update_repo {
  sudo add-apt-repository ppa:nginx/stable

  sudo apt-get update
}

function install_node {
  curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
  sudo apt-get install -y nodejs
  sudo apt-get install -y build-essential
  sudo npm install yarn -g
}
function setup_vault {
  echo "---Installing Vault---"

  sudo apt-get install jq unzip -y
  sudo curl https://releases.hashicorp.com/vault/0.10.1/vault_0.10.1_linux_amd64.zip -o vault.zip
  unzip vault.zip
  sudo mv vault /usr/local/bin/vault

}

function install_nginx {
  echo "---Installing NGINX---"
  sudo apt-get install nginx -y
  sudo systemctl start nginx
}
function setup_nginx {
  echo "---Setting up NGINX---"

  sudo mv /tmp/gzip.conf /etc/nginx/conf.d/gzip.conf
  sudo rm -rf /etc/nginx/sites-available/default
  sudo mv /tmp/nginx-config /etc/nginx/sites-available/default
  sudo chown root:root /etc/nginx/sites-available/default
  sudo systemctl restart nginx
  sudo systemctl status nginx
}
function move_startup_script {
  sudo mv /tmp/startup-script.sh $HOME/startup-script.sh
}
function install_config_filebeats {
  wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
  sudo apt-get -y install apt-transport-https
  echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
  sudo apt-get update
  sudo apt-get install -y filebeat metricbeat
  sudo update-rc.d filebeat defaults 95 10
  sudo mkdir -p /etc/pki/tls/certs
  sudo cp /tmp/logstash-forwarder.crt /etc/pki/tls/certs/
  sudo mv /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.old.yml
  sudo cp /tmp/filebeat-config.yml /etc/filebeat/filebeat.yml
  sudo filebeat modules enable nginx system
  echo "---Restarting filebeat---"

  sudo service filebeat restart
  sudo update-rc.d filebeat defaults 95 10
}
function config_metricbeats {
  sudo mv /etc/metricbeat/metricbeat.yml /etc/metricbeat/metricbeat.old.yml
  sudo cp /tmp/metricbeat-config.yml /etc/metricbeat/metricbeat.yml
  sudo metricbeat modules enable nginx system
  sudo service metricbeat restart
  sudo update-rc.d metricbeat defaults 95 10
}
function check_status_beats {
  echo "---filebeat status---"

  sudo filebeat test config
  sudo filebeat test output
  echo "---metricbeat filebeat---"

  sudo metricbeat test output
  sudo metricbeat test config
}
function main {
  update_repo
  install_node
  install_nginx
  setup_nginx
  move_startup_script
  setup_vault
  install_config_filebeats
  config_metricbeats
}

main


