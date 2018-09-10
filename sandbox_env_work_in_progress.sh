#!/usr/bin/env/ bash

staging_image_variables() {
    VARIABLES+=(
        'PROJECT_ID'
        'SERVICE_ACCOUNT_PATH'
        'STREAMER_PASSWORD'
        'DB_PASSWORD'
        'DATABASE_IP'
        'DATABASE_HOST'
        'ELASTICSEARCH_HOST'
        'BACKEND_HOST'
        'FRONTEND_HOST'
        'BARMAN_STREAMER_IP'
        'EXTERNAL_CONNECTION_FE'
        'EXTERNAL_CONNECTION_BE'
        'NGINX_SERVER_NAME'
        'KIBANA_PASSWORD'
        'platform_name'
        'mrm_vault_auth_token'
        'db_password'
        'api_secret_key'
        'bugsnag_api_token'
    )

    PROJECT_ID="learning-map-app"
    SERVICE_ACCOUNT_PATH="${DIRECTORY}/images/shared/google-creds-staging.json"
    DATABASE_IP="192\\.168\\.13\\.130"
    # backend and frontend filebeat and metricbeat
    ELASTICSEARCH_HOST="mrm-elk-server"
    # backend and barman
    BACKEND_HOST="mrm-backend-instance"
    FRONTEND_HOST="mrm-frontend-instance"
    DATABASE_HOST="mrm-postgresql-server"
    DB_PASSWORD="4StEcZTJDfqBx2Xa"
    db_password="4StEcZTJDfqBx2Xa"
    api_secret_key="5X#E?3eJCdrAhNp_"
    bugsnag_api_token="80cae68eccef88ed018a1d3523e4c2bd"

    #sandbox postgres
    BARMAN_STREAMER_IP="192\\.168\\.13\\.201/32"
    EXTERNAL_CONNECTION_FE="192\\.168\\.1\\.0/24"
    EXTERNAL_CONNECTION_BE="192\\.168\\.13\\.0/24"
    STREAMER_PASSWORD="wywywpqpiP@OP@PJNOMP090873"


    #sandbox ELK
    NGINX_SERVER_NAME="converge-kibana\\.andela\\.com"

    #sandbox kibana
    KIBANA_PASSWORD="mrmkibanaUnusedPassw0rd1234SS08"

    #metadata_prefix
    platform_name="\"mrm-staging\""

    #vault, backend, frontend start-up scripts
    mrm_vault_auth_token="staging_mrm_vault_auth_token"

}

staging_terraform_variables() {
    # sandbox
    VARIABLES+=(
        'gcloud_region'
        'gcloud_zone'
        'vpc_cidr'
        'elk_server'
        'platform_name'
        'gcloud_project'
        'subnet_cidrs'
        'static_ips'
        'bucket'
        'service_account_path'
        'init_service_account_path'
        'frontend_address_name'
        'backend_address_name'
        'app_settings'
        'mrm_url'
        'mrm_api_url'
        'andela_login_url'
        'andela_api_url'
        'environment'
		'mail_server'
		'mail_port'
		'mail_use_tls'
		'mail_username'
		'mail_password'
		'celery_broker_url'
		'celery_result_backend'
    )

    # terraform variables
    gcloud_region="\"europe-west1\""
    gcloud_zone="\"europe-west1-b\""
    service_account_path="\".\\/google-creds-sandbox.json\""
    init_service_account_path="\"./google-creds-sandbox.json\""
    vpc_cidr="\"192\\.168\\.0\\.0\\/16\""
    elk_server="\"elk-server\""
    platform_name="\"mrm-staging\""
    frontend_address_name="\"130.211.19.225\""
    backend_address_name="\"35.201.82.45\""
    gcloud_project="\"andela-learning\""
    subnet_cidrs="{\n\tprivate-fe-be = \"192\\.168\\.1\\.0\\/24\", \n\tprivate-db-va = \"192\\.168\\.13\\.0\\/24\", \n\tpublic = \"192\\.168\\.200\\.0\\/24\"\n\t}"
    static_ips="{\n\telk-server = \"192\\.168\\.200\\.104\", \n\tvault-server = \"192\\.168\\.13\\.101\", \n\tpostgres-server = \"192\\.168\\.13\\.130\", \n\tredis-server = \"192\\.168\\.13\\.135\", \n\tbarman-server = \"192\\.168\\.13\\.201\"\n\t}"
    bucket="\"mrm-tf-staging-state\""

    # instance metadata
    app_settings="\"production\""
    mrm_url="\"https:\\/\\/converge-front\\.andela\\.com\""
    mrm_api_url="\"https:\\/\\/converge-api\\.andela\\.com\\/mrm\""
    andela_login_url="\"https:\\/\\/api-staging\\.andela\\.com\\/login?redirect_url\""
    andela_api_url="\"https:\\/\\/docs\\.andela\\.com\""
    environment="\"sandbox\""
    
	# Flask-Mail configuration
	mail_server="\"smtp\\.gmail\\.com\""
	mail_port="\"587\""
	mail_use_tls="\"True\""
	mail_username="\"mikemutoro@gmail\\.com\""
	mail_password="\"Michael1991\""

	# Celery configuration
	celery_broker_url="\"redis:\\/\\/192\\.168\\.13\\.135:6379\\/0\""
	celery_result_backend="\"redis:\\/\\/192\\.168\\.13\\.135:6379\\/0\""
}
