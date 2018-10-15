#/bin/bash

# Download and install vault
function download_vault {
  echo "--- Downloading Vault Server ---"
  sudo apt-get update
  sudo apt-get install unzip -y
  sudo curl https://releases.hashicorp.com/vault/0.10.1/vault_0.10.1_linux_amd64.zip -o vault.zip
  unzip vault.zip
  sudo mv vault /usr/local/bin/vault
  sudo setcap cap_ipc_lock=+ep /usr/local/bin/vault
  sudo useradd -r -d /var/lib/vault -s /bin/nologin vault
  sudo install -o vault -g vault -m 750 -d /var/lib/vault
  echo ">>> Vault Server Downloaded"
}
function init_vault {
  echo "--- Initialising Vault Server ---"
  export VAULT_ADDR=http://127.0.0.1:8200

  rm -f vault_tokens
  touch vault_tokens
  vault operator init >> vault_tokens
  echo ">>> Initialised Vault Server"
}
function start_vault_server {
  sudo chown vault:vault /home/packer/mrm-vault-config-file.hcl
  sudo chmod 640 /home/packer/mrm-vault-config-file.hcl

  sudo touch /etc/systemd/system/vault.service

  cat /tmp/vault.service | sudo tee --append /etc/systemd/system/vault.service

  echo "--- Starting Vault Server ---"
  sudo systemctl start vault
  sleep 5

  sudo systemctl status vault
  sudo systemctl enable vault

  echo ">>> Started Vault Server"
}
function write_policy {
  echo "--- Writing Policy ---"
  vault policy write mrm-policy /home/packer/mrm-vault-policy.hcl
  echo ">>> Written Policy"
}
function mount_path {
  echo "--- Mounting Path ---"
  vault secrets enable -path=mrm -description="mrm keypath" kv
  echo ">>> Path Mounted"
}
function unseal_vault {
  echo "--- Unsealing Vault Server ---"

  vault operator unseal $(get_Token 1)
  vault operator unseal $(get_Token 3)
  vault operator unseal $(get_Token 4)
}
function get_Token {
  echo $(cat vault_tokens | sed -n $1p | cut -d ':' -f 2 | cut -d ' ' -f 2)
}
function auth_vault {
  echo "--- Authentication Vault Server ---"
  vault login $(get_Token 7)
  echo ">>> Vault Server Authenticated---"
}
function write_key_to_vault {
  echo "--- Writing Keys to Vault Server ---"
  touch /home/packer/github_key_private.pub
  touch /home/packer/github_key_private
  cat /tmp/github_key_private >> /home/packer/github_key_private
  cat /tmp/github_key_private.pub >> /home/packer/github_key_private.pub
  sudo chown vault:vault /home/packer/github_key_private.pub
  sudo chown vault:vault /home/packer/github_key_private
  vault write mrm/keys mrm_token_verifier_pub_key=@/home/packer/github_key_private.pub mrm_repo_private_key=@/home/packer/github_key_private mrm_api_secret_key="$1"
  echo ">>> Keys written to Vault Server ---"
}
function create_cron_job {
  sudo crontab -u packer /tmp/renew-token
}
function write_postgres_details_to_vault {
  echo "---Writing db variables to vault---"
  vault write mrm/postgresdb mrm_db_username="postgres" mrm_db_password="$1"
}
#Add bugsnag API token to vault
function write_bugsnag_token_to_vault {
  vault write mrm/bugsnag mrm_bugsnag_token="$3"
}

function main {
  download_vault
  start_vault_server
  init_vault
  unseal_vault
  auth_vault
  write_policy
  mount_path
  write_key_to_vault $2
  write_postgres_details_to_vault $1
  write_bugsnag_token_to_vault $3
  create_cron_job
}
main $1 $2 $3
