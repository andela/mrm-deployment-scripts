#!/bin/bash

function clean_up {
        sudo su postgres
        cd
        sudo -H -u postgres psql -c "REVOKE ALL PRIVILEGES ON DATABASE back FROM back;"
        sudo -H -u postgres psql -c "DROP USER back;"
        sudo -H -u postgres psql -c "DROP DATABASE back;"
}

function set_up {
        sudo -H -u postgres psql -c "CREATE DATABASE back;"
        sudo -H -u postgres psql -c "CREATE USER back WITH PASSWORD 'back';"
        sudo -H -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE back TO back;"
}

function make_backup {
        sudo -H -u postgres psql back < backup.sql
}
clean_up
set_up
if [[ $(make_backup) ]]; then
        echo "backup created"
else
        echo "backup failed"
fi
clean_up
