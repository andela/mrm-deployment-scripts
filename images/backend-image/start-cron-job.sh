#!/bim/bash

function start_cron_job {
    cd /home/packer/
    cd /var/lib/postgresql/
    sudo su - postgres -c "mkdir -p /var/lib/postgresql/backup"
    sudo mv /home/packer/start-cron-job.sh /home/packer/backup.sh /home/packer/cronjob /home/packer/validate.sh /var/lib/postgresql/
    crontab -u packer /var/lib/postgresql/cronjob
}

if [[ $(get_instance_metadata "environment") == "production" ]]; then
    start_cron_job
fi
