#!/bin/bash
source /home/packer/venv/bin/activate && export $(cat /home/packer/mrm_api/.env | xargs)
printenv
echo $APP_SETTINGS 
cd /home/packer/mrm_api
celery worker -A celery_worker.celery --loglevel=info
