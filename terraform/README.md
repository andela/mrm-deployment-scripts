## Terraform Infrastructure Build Guide

[Terraform](https://www.terraform.io/) is Hashicorps open source tool that enables one to safely create, change, and improve infrastructure on any cloud provider. It is used in this project to automate infrastructure deployment to the Google Cloud Platform.
In other to make a successful deployment of the terraform scripts to GCP, first [download](https://www.terraform.io/downloads.html) and install terraform and ensure to adhere to the steps as stated below:

### Steps
- Get the service account information : [Download Service Account](../docs/service-account-creation)
- Move the downloaded service account key file to the project directory
- Change the **credentials** value from the file `terraform/providers.tf` in both **provider** and **data** objects to the path you moved the downloaded service account file
- Create a file `terraform-init` and pass in the following contents
```
bucket="GCS Bucket Name"
prefix="terraform/state"
path="terraform/state"
credentials="/path/to/service/account/file"
```
- Run the command `terraform init -backend-config=/path/to/terraform-init`
- Run `terraform plan`