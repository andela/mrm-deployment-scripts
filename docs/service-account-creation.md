## Creating A Service Account

In order to deploy images or infrastructure using terraform to your Google Cloud Platform project, it is important that you create a service account and download a keyfile.
This guide hopes to guide you through that process
1. Navigate to the [Service Accounts](https://console.cloud.google.com/iam-admin/serviceaccounts?_ga=2.259599498.-1227050136.1526405402) page on GCP console
2. Select your GCP project name and open
3. Click **Create Service Account**
4. Enter a service account name
5. select a role to grant to the service account
6. Click the check box that says - Furnish a new private key
6. click Create.

**Note:** The JSON file downloaded should be protected from unauthorized users and added to *.gitignore* file thereby preventing from being commited to the repository.