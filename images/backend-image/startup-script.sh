#/bin/bash

function create_repo_key {
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
function get_vault_address {
  echo $(curl http://metadata.google.internal/computeMetadata/v1/project/attributes/mrm_vault_server_IP -H "Metadata-Flavor: Google")
}
function login_vault {
  vault_token=$(curl http://metadata.google.internal/computeMetadata/v1/project/attributes/mrm_vault_auth_token -H "Metadata-Flavor: Google")
  export VAULT_ADDR="http://$(get_vault_address):8200"

  echo "---Authenticating on Vault Server---"

  vault login ${vault_token}
}
function clone_repo {
  echo "---cloning repo---"
  git clone git@github.com:andela/mrm_api.git
}
function install_project_dependencies {
  echo "---Installing dependencies---"

  cd mrm_api
  pip install -r requirements.txt

}
function count_versions {
  echo $(find alembic/versions/*.py | wc -l)
}
function retrieve_env_variables {
  echo "---Retrieving env variables---"
  curl http://metadata.google.internal/computeMetadata/v1/project/attributes/mrm_env -H "Metadata-Flavor: Google" > .env
}
function get_db_username {
  echo $(vault read -format="json" mrm/postgresdb | jq -r .data.mrm_db_username)
}
function get_db_password {
  echo $(vault read -format="json" mrm/postgresdb | jq -r .data.mrm_db_password)
}
function retrieve_secret_key {
  echo $(vault read -format="json" mrm/keys | jq -r .data.mrm_api_secret_key)
}
function database_url {
  echo "postgresql://$(get_db_username):$(get_db_password)@192.168.13.130:5432/postgres"
}
function setup_env_variables {
  echo "---Setting env variables---"

  if [ -s .env ]; then
    while read new_line || [[ -n $new_line ]]; do
      printf "\t$new_line,\n" | sudo tee --append /etc/supervisor/conf.d/mrm_api.conf
    done <.env
  fi
  echo "---exporting env variables---"
  printf "\tDATABASE_URL=\"$(database_url)\",\n" | sudo tee --append /etc/supervisor/conf.d/mrm_api.conf

  printf "\tDEV_DATABASE_URL=\"$(database_url)\",\n" | sudo tee --append /etc/supervisor/conf.d/mrm_api.conf
  printf "\tSECRET_KEY=\"$(retrieve_secret_key)\"\n" | sudo tee --append /etc/supervisor/conf.d/mrm_api.conf
}
function run_migration {
  echo "---Running db migrations---"
  if [ -d "alembic/versions" ]; then
    if [ "$(count_versions)" -eq 0 ]; then
      alembic revision --autogenerate
    elif [ "$(count_versions)" -gt 0 ] && [ "$(count_versions)" -lt 2 ]; then
      alembic stamp head
    elif [ "$(count_versions)" -gt 2 ]; then
      alembic stamp head
      alembic upgrade head
      alembic revision --autogenerate
    fi

    alembic upgrade head
  fi


}
function run_application {
  sudo supervisorctl reread
  sudo supervisorctl update
  sudo service supervisor restart
  sudo supervisorctl start mrm_api
}
function use_venv {
  virtualenv --python=python3 venv
  source venv/bin/activate
}
function install_other_dependencies {
  pip install gunicorn
  pip install gevent
}


function main {
  login_vault
  create_repo_key
  use_venv
  clone_repo
  install_project_dependencies
  install_other_dependencies
  retrieve_env_variables
  setup_env_variables
  run_migration
  run_application
  sudo filebeat setup --template -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["mrm-elk-server:9200"]'
  sudo metricbeat setup

}
main "$@"
