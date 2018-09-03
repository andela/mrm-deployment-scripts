sudo su - postgres -c "pg_dump -F p -f /var/lib/postgresql/backup/db-backup-`date +\"%Y\"`-`date +\"%m\"`-`date +\"%d\"`.sql"
sudo gsutil cp \/var\/lib\/postgresql\/backup\/db-backup-*.sql gs://mrm-production-backup/
sudo rm -r /var/lib/postgresql/backup/db-*
