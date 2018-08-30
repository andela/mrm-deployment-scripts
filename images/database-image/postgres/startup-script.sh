#!/bim/bash 

function get_instance_metadata {
  local name="$1"

  curl -s -H "Metadata-Flavor: Google" \
    "http://metadata.google.internal/computeMetadata/v1/instance/attributes/${name}"
}

function start_cron_job {
  cd /home/packer/
  sudo su postgres
  cd /var/lib/postgresql/
  sudo su - postgres -c "mkdir -p /var/lib/postgresql/backup"
  sudo mv /home/packer/startup-script.sh /home/packer/backup.sh /home/packer/cronjob /home/packer/post_backup_to_bucket.sh /var/lib/postgresql/
  crontab -u packer /var/lib/postgresql/cronjob
}

if [[ $(get_instance_metadata "environment") == "production" ]]; then
	start_cron_job
fi
