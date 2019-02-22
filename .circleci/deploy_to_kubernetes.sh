#!/usr/bin/env bash

deploy(){
	touch terraform-init
	if [ "$CIRCLE_BRANCH" == master ]; then
		# set credentials
		echo $GOOGLE_CREDENTIALS_SANDBOX | base64 --decode > secrets/google-creds-sandbox.json
		echo $GOOGLE_CREDENTIALS_PRODUCTION | base64 --decode > secrets/google-creds-production.json
		# get certificates
		gsutil cp gs://$PRODUCTION_BUCKET/ssl/andela_certificate.pem secrets/ssl_andela_certificate.crt
		gsutil cp gs://$PRODUCTION_BUCKET/ssl/ssl_andela_key.key secrets/ssl_andela_key.key
		# create terraform-init
		echo "bucket=\"$PRODUCTION_BUCKET\"" >> terraform-init
		echo "prefix=\"$PRODUCTION_PREFIX\"" >> terraform-init
		echo "credentials=\"$PRODUCTION_CREDENTIALS\"" >> terraform-init
		cat terraform-init
		cat main.tf
		# initilise terraform
		terraform init -backend-config=terraform-init
		# Get the current state
		gsutil cp gs://$PRODUCTION_BUCKET/$PRODUCTION_PREFIX/default.tfstate terraform.tfstate
		# make terraform plan and apply the gke module
		terraform plan -target module.gke
		terraform apply -target module.gke -auto-approve
		# set credentials of the kerbernetes cluster
		gcloud container clusters get-credentials converge-$PRODUCTION_ENVIRONMENT
		# make terraform plan and apply the k8s module
		terraform plan -target module.k8s
		terraform apply -target module.k8s -auto-approve
		# update the state
		gsutil cp terraform.tfstate gs://$PRODUCTION_BUCKET/$PRODUCTION_PREFIX/default.tfstate
	elif [ "$CIRCLE_BRANCH" == develop ]; then
		# set credentials
		echo $GOOGLE_CREDENTIALS_SANDBOX | base64 --decode > secrets/google-creds-sandbox.json
		echo $GOOGLE_CREDENTIALS_STAGING | base64 --decode > secrets/google-creds-staging.json
		# get certificates
		gsutil cp gs://$STAGING_BUCKET/ssl/andela_certificate.pem secrets/ssl_andela_certificate.crt
		gsutil cp gs://$STAGING_BUCKET/ssl/ssl_andela_key.key secrets/ssl_andela_key.key
		# create terraform-init
		echo "bucket=\"$STAGING_BUCKET\"" >> terraform-init
		echo "prefix=\"$STAGING_PREFIX\"" >> terraform-init
		echo "credentials=\"$STAGING_CREDENTIALS\"" >> terraform-init
		cat terraform-init
		cat main.tf
		# initilise terraform
		terraform init -backend-config=terraform-init
		# Get the current state
		gsutil cp gs://$STAGING_BUCKET/$STAGING_PREFIX/default.tfstate terraform.tfstate
		# make terraform plan and apply the gke module
		terraform plan -target module.gke
		terraform apply -target module.gke -auto-approve
		# set credentials of the kerbernetes cluster
		gcloud container clusters get-credentials converge-$STAGING_ENVIRONMENT
		# make terraform plan and apply the k8s module
		terraform plan -target module.k8s
		terraform apply -target module.k8s -auto-approve
		# update the state
		gsutil cp terraform.tfstate gs://$STAGING_BUCKET/$STAGING_PREFIX/default.tfstate
	else
		# set credentials
		echo $GOOGLE_CREDENTIALS_SANDBOX | base64 --decode > secrets/google-creds-sandbox.json
		echo $GOOGLE_CREDENTIALS_STAGING | base64 --decode > secrets/google-creds-staging.json
		# get certificates
		gsutil cp gs://$SANDBOX_BUCKET/ssl/andela_certificate.pem secrets/ssl_andela_certificate.crt
		gsutil cp gs://$SANDBOX_BUCKET/ssl/ssl_andela_key.key secrets/ssl_andela_key.key
		# create terraform-init
		echo "bucket=\"$SANDBOX_BUCKET\"" >> terraform-init
		echo "prefix=\"$SANDBOX_PREFIX\"" >> terraform-init
		echo "credentials=\"$SANDBOX_CREDENTIALS\"" >> terraform-init
		cat terraform-init
		cat main.tf
		# initilise terraform
		terraform init -backend-config=terraform-init
		# Get the current state
		gsutil cp gs://$SANDBOX_BUCKET/$SANDBOX_PREFIX/default.tfstate terraform.tfstate
		# make terraform plan and apply the gke module
		terraform plan -target module.gke
		terraform apply -target module.gke -auto-approve
		# set credentials of the kerbernetes cluster
		gcloud container clusters get-credentials converge-$SANDBOX_ENVIRONMENT
		# make terraform plan and apply the k8s module
		terraform plan -target module.k8s
		terraform apply -target module.k8s -auto-approve
		# update the state
		gsutil cp terraform.tfstate gs://$SANDBOX_BUCKET/$SANDBOX_PREFIX/default.tfstate
	fi
}
