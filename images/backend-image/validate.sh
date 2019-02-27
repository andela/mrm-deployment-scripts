#!/bin/bash

source /home/packer/common-functions.sh

function get_latest_backup {
        file="$(sudo gsutil ls $BACKUPS_PATH | tail -n 1)"
        sudo mkdir restore
        sudo gsutil cp $file restore/
        ls restore/
}

function clean_up {
        sudo -H -u postgres PGPASSWORD=$DATABASE_PASSWORD psql -h $DATABASE_IP -U $DATABASE_USERNAME -p 5432 -c "REVOKE ALL PRIVILEGES ON DATABASE back FROM $DATABASE_USERNAME;"
        sudo -H -u postgres PGPASSWORD=$DATABASE_PASSWORD psql -h $DATABASE_IP -U $DATABASE_USERNAME -p 5432 -c "DROP DATABASE back;"
        sudo rm -r restore
}

function set_up {
        sudo -H -u postgres PGPASSWORD=$DATABASE_PASSWORD psql -h $DATABASE_IP -U $DATABASE_USERNAME -p 5432 -c "CREATE DATABASE back;"
        sudo -H -u postgres PGPASSWORD=$DATABASE_PASSWORD psql -h $DATABASE_IP -U $DATABASE_USERNAME -p 5432 -c "GRANT ALL PRIVILEGES ON DATABASE back TO $DATABASE_USERNAME;"
        error=$(sudo -H -u postgres PGPASSWORD=$DATABASE_PASSWORD psql -U $DATABASE_USERNAME -d back -h $DATABASE_IP -p 5432 < /var/lib/postgresql/restore/"$(get_latest_backup)" 2>&1)
}

set_up

if [[ $? == 0 ]]; then
    echo "validation successful"
else
    echo $error
    echo "validattion failed"
fi

clean_up
