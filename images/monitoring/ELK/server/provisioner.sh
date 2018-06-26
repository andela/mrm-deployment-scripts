#!/usr/bin/env bash

function install_Java {
  sudo apt-get install -y python-software-properties debconf-utils
    sudo add-apt-repository -y ppa:webupd8team/java
    sudo apt-get update
    echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
    echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
    sudo apt-get install -y oracle-java8-installer
}
function install_elastic_search {
  wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
  sudo apt-get -y install apt-transport-https
  echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
  sudo apt-get update
  sudo apt-get -y install elasticsearch
}
function modify_elastic_conf {
  echo "network.host: [localhost, _site_]" | sudo tee --append /etc/elasticsearch/elasticsearch.yml
  sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install ingest-geoip <<< 'y'

  sudo service elasticsearch restart

  sudo /bin/systemctl daemon-reload
  sudo /bin/systemctl enable elasticsearch.service
  sudo systemctl restart elasticsearch.service
}
function modify_kibana_conf {
  echo "server.host: localhost" | sudo tee --append /etc/kibana/kibana.yml
  sudo service kibana restart

  sudo /bin/systemctl daemon-reload
  sudo /bin/systemctl enable kibana.service
  sudo systemctl restart kibana.service
}
function install_kibana {
  sudo apt-get -y install kibana
}
function install_nginx_and_conf {
  sudo apt-get -y install nginx apache2-utils
  sudo htpasswd -c -i /etc/nginx/htpasswd.users kibanaadmin <<< "$1"
  sudo rm -rf /etc/nginx/sites-available/default
  sudo mv /tmp/nginx-config /etc/nginx/sites-available/default

  sudo mkdir /etc/nginx/ssl
  sudo cp /tmp/nginx.crt /etc/nginx/ssl/nginx.crt
  sudo cp /tmp/nginx.key /etc/nginx/ssl/nginx.key

  sudo chmod 400 /etc/nginx/ssl/nginx.key

  sudo systemctl restart nginx
  sudo systemctl status nginx

}
function install_logstash {
  sudo apt-get -y install logstash
}
function config_certs {
  sudo mkdir -p /etc/pki/tls/certs
  sudo mkdir /etc/pki/tls/private
  sudo mv /tmp/logstash-forwarder.crt /etc/pki/tls/certs/logstash-forwarder.crt
  sudo mv /tmp/logstash-forwarder.key /etc/pki/tls/private/logstash-forwarder.key
}
function config_logtash {
  sudo mv /tmp/logstash-beats.conf /etc/logstash/conf.d/02-beats-input.conf
  sudo mv /tmp/syslog-filter.conf /etc/logstash/conf.d/10-syslog-filter.conf
  sudo mv /tmp/nginx-filter.conf /etc/logstash/conf.d/11-nginx-filter.conf
  sudo mv /tmp/elasticsearch-output.conf /etc/logstash/conf.d/30-elasticsearch-output.conf
  sudo systemctl start logstash.service

  sudo /bin/systemctl daemon-reload
  sudo /bin/systemctl enable logstash.service
  sudo systemctl restart logstash.service

}

function config_index_patterns {
  cd ~/
  sudo cp /tmp/filebeat-patterns.json ~/filebeat.template.json
  sudo cp /tmp/metricbeat-patterns.json ~/metricbeat.template.json
  curl -XPUT -H 'Content-Type: application/json' http://localhost:9200/_template/metricbeat-6.2.4 -d@metricbeat.template.json
  curl -XPUT -H 'Content-Type: application/json' http://localhost:9200/_template/filebeat-6.2.4 -d@filebeat.template.json
}
function main {
  install_Java
  install_elastic_search
  modify_elastic_conf
  install_kibana
  modify_kibana_conf
  install_nginx_and_conf $1
  config_certs
  install_logstash
  config_logtash
}
main $1

