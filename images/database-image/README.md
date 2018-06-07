# Database and Backup Images

These images install and configure [postgres](<https://www.postgresql.org/>) and [barman](<https://www.pgbarman.org/>) instances

## Introduction

PostgreSQL is an open source Object relational database system.

Barman (Backup and Recovery Manager) is an open source disaster Recovery tool for postgreSQL servers

## Before you begin

### Step 1

Duplicate the tmpl files in each directory and rename them

- Rename the [postgres/postgresql-template.json.tmpl](postgres/postgresql-template.json.tmpl) file to `postgres/postgresql-template.json`
- Rename the [barman/barman-template.json.tmpl](barman/barman-template.json.tmpl) file to `barman/barman-template.json`

Modify Template Files

- Modify the files such that `"account_file": "{{ user \`gcloud_account_file\` }}"` is changed to the path of your gcloud service account file

### Step 2

Generate an ssh key

> - Create a directory called secret in the root repo directory
> - Generate an SSH key and store in the directory created : store generated ssh key as postgres_rsa
> `ssh-keygen -t rsa -N ""`

### Step 3

Duplicate and modify Public key

> - Duplicate the postgres_rsa.pub key and name it barman_rsa.pub
> - Modify the `barman_rsa.pub` file such that it ends with `barman@mrm-backup-instance` after the key
> - Modify the `postgres_rsa.pub` file such that it ends with `postgres@mrm-postgres-instance`

These ensure that the 2 servers can communicate over ssh

**Note:** You would have to ensure that the location in your template file matches the location of the secret files

## Step 4

Provide the environmental variables:

`DB_PASSWORD`

> - This would be the password used to login to the default postgres user on the database
> - You can use the command:
>  `export DB_PASSWORD=[passwrord]`
> - `[password]` is the new password

`STREAMER_PASSWORD`

> - This would be the password barman uses to connect to the database
> - You can use the command:
>  `export STREAMER_PASSWORD=[passwrord]`
> - `[password]` is the password

## Step 5

Validate and build packer templates for both the [postgreSQL images](postgres/postgresql-template.json.tmpl) and the [barman images](barman/barman-template.json.tmpl)

`packer vaildate [image]`
`packer build [image]`
