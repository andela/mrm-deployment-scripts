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
function install_config_filebeats {
  echo "---Upgrading Filebeat and metricbeats---"

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
  sudo filebeat modules enable system
  echo "---Restarting filebeat---"

  sudo service filebeat restart
  sudo update-rc.d filebeat defaults 95 10
}
function config_metricbeats {
  sudo mv /etc/metricbeat/metricbeat.yml /etc/metricbeat/metricbeat.old.yml
  sudo cp /tmp/metricbeat-config.yml /etc/metricbeat/metricbeat.yml
  sudo metricbeat modules enable system
  sudo sed -i -e 's/period: 10s/period: 100s/g' /etc/metricbeat/modules.d/system.yml
  sudo service metricbeat restart
  sudo update-rc.d metricbeat defaults 95 10
}
function move_startup_script {
  sudo mv /tmp/startup-script.sh $HOME/startup-script.sh
}
function move_supervisor_script {
  sudo mv /tmp/mrm_api.conf /etc/supervisor/conf.d/mrm_api.conf
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
  install_dependencies
  move_startup_script
  move_supervisor_script
  setup_vault
  install_config_filebeats
  config_metricbeats
  check_status_beats
}
main
