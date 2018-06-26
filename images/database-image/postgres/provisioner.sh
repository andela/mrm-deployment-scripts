#!/bin/bash

function install_postgresql {
  echo "---Installing postgres db---"
  sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
  sudo apt-get update
  sudo apt-get install postgresql postgresql-contrib -y
}
function install_adminpack {
  sudo -u postgres psql -c "CREATE EXTENSION adminpack"
}

function create_barman_user {
  sudo -u postgres psql -c "ALTER USER postgres WITH encrypted password '$1'"
  sudo -u postgres psql -c "CREATE ROLE barmanstreamer WITH REPLICATION SUPERUSER PASSWORD '$2' LOGIN"
}
function enable_logging {
  echo "log_duration = on" | sudo tee --append $CONF_FILE
  echo "log_statement = 'none'" | sudo tee --append $CONF_FILE
  echo "log_min_duration_statement = 2000" | sudo tee --append $CONF_FILE
  echo "client_min_messages = notice" | sudo tee --append $CONF_FILE
  echo "log_min_messages = warning" | sudo tee --append $CONF_FILE
  echo "log_min_error_statement = error" | sudo tee --append $CONF_FILE
}
function get_postgres_version {
  echo $(ls /etc/postgresql)
}

function enable_external_connections {
  echo "---Modifying conf file, allowing eternal connections---"
  echo "listen_addresses = '*'" | sudo tee --append $CONF_FILE
}

function enable_WAL {
  echo "---Modifying conf file, Write Ahead LOG---"
  echo "wal_level = hot_standby" | sudo tee --append $CONF_FILE
  echo "max_wal_senders = 3" | sudo tee --append $CONF_FILE
  echo "max_replication_slots = 2" | sudo tee --append $CONF_FILE

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
  sudo filebeat modules enable postgresql system
  echo "---Restarting filebeat---"

  sudo service filebeat restart
  sudo update-rc.d filebeat defaults 95 10
}
function config_metricbeats {
  sudo mv /etc/metricbeat/metricbeat.yml /etc/metricbeat/metricbeat.old.yml
  sudo cp /tmp/metricbeat-config.yml /etc/metricbeat/metricbeat.yml
  sudo metricbeat modules enable system postgresql
  sudo service metricbeat restart
  sudo update-rc.d metricbeat defaults 95 10
}
function start_postgres_onboot {
  sudo systemctl enable postgresql
}

function allow_barman_streamer_access {
  echo "---including barmanstreamer access---"
  echo "host    replication     barmanstreamer           172.16.13.201/32        trust" | sudo tee --append $HBA_FILE
}

function allow_external_connection {
  echo "---Allow md5 auth from local network---"
  echo "host    all             all           172.16.1.0/24         md5" | sudo tee --append $HBA_FILE
  echo "host    all             all           172.16.13.0/24         md5" | sudo tee --append $HBA_FILE
}

function copy_keys {
  echo "---Copying public key to authorized"

  if [ ! -d /var/lib/postgresql/.ssh ]; then
    echo "---creating directory---"
    sudo su - postgres -c "mkdir -p /var/lib/postgresql/.ssh"
    sudo su - postgres -c "chmod 700 /var/lib/postgresql/.ssh"
    echo "Directory Created>>>"
  fi

  sudo su - postgres -c "cat /tmp/barman_rsa.pub >> /var/lib/postgresql/.ssh/authorized_keys"
  sudo cat /var/lib/postgresql/.ssh/authorized_keys
  echo "---modifying permission on public key---"
  sudo su - postgres -c "chmod 600 /var/lib/postgresql/.ssh/authorized_keys"
  echo "---copying keys---"
  sudo cp /tmp/postgres_rsa /var/lib/postgresql/.ssh/id_rsa
  sudo su - postgres -c "cp /tmp/postgres_rsa.pub /var/lib/postgresql/.ssh/id_rsa.pub"
  sudo chown postgres:postgres /var/lib/postgresql/.ssh/id_rsa
  sudo su - postgres -c "chmod 600 /var/lib/postgresql/.ssh/id_rsa"
  echo "private keys copied"
  sudo ls -l /var/lib/postgresql/.ssh/

}
function main {
  install_postgresql
  install_adminpack
  export CONF_FILE="/etc/postgresql/$(get_postgres_version)/main/postgresql.conf"
  export HBA_FILE="/etc/postgresql/$(get_postgres_version)/main/pg_hba.conf"
  copy_keys
  create_barman_user $1 $2
  allow_barman_streamer_access
  enable_logging
  enable_WAL
  enable_external_connections
  allow_external_connection
  start_postgres_onboot
  echo "--- Restarting postgresql ---"
  sudo systemctl restart postgresql
  install_config_filebeats
  config_metricbeats
}
main $1 $2
