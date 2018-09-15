# Google Cloud Playground

This repository contains the code to bring up a Kubernetes cluster on Google
Cloud. The Google Cloud trial account gives $300 credit to play with for a year;
this is a great way to experiment with Google Cloud.


## Prerequisites

This repository uses a Vagrant virtual machine as a controller for provisioning
resources on Google Cloud; this has only been tested with VirtualBox.

- Google Cloud Account
- Vagrant
- VirtualBox


## Start Controller VM

The Vagrant will pull an Ubuntu 16.04 LTS image and prevision the VM with the
required tools. The host machine's Google Cloud configuration directory
(`~/.config/gcloud`) is mounted in the VM; this will need created if not
present.

Start the local virtual machine and login to the Google Cloud account

```sh
user@host$ vagrant up
user@host$ vagrant ssh
vagrant@guest$ gcloud auth login
```


## Setup Environment.

This repository is setup to use the following environmental variables. The
project must be unique within the Google Cloud infrastructure.

```sh
export TF_VAR_project=fluffy-kitty
export TF_VAR_credentials=~/.config/gcloud/deploy-${TF_VAR_project}.json
export TF_VAR_bucket=${TF_VAR_project}-terraform-state
export TF_VAR_ssh_user=joshua.david.foster
export ANSIBLE_REMOTE_USER=${TF_VAR_ssh_user}
```

## Infrastructure Deployment

Navigate to the `~/infrastructure` directory.

### Create Project and Service Account

Users are required to be members of a Google Cloud organisation group to be able
to grant a service account with project creation permissions. This can be
validated by using the `gcloud organizations list` command, this will list group
membership for the user. While there is a free tier for Google Cloud Identity
this requires registration and validation of a domain. This guide demonstrates
creating a project using the users credentials then defer subsequent request to
the service account.

```sh
gcloud projects create ${TF_VAR_project} --set-as-default
```


### Create deploy user, grant permissions and generate keys.

```sh
gcloud iam service-accounts create deploy --display-name "Infrastructure deployment account"
gcloud iam service-accounts keys create ${TF_VAR_credentials} --iam-account deploy@${TF_VAR_project}.iam.gserviceaccount.com
gcloud projects add-iam-policy-binding ${TF_VAR_project} --member serviceAccount:deploy@${TF_VAR_project}.iam.gserviceaccount.com --role roles/owner
```

A billing account must be added manually via the
[Google Cloud console](https://console.developers.google.com/billing/linkedaccount).


### Enable required APIs

```sh
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable compute.googleapis.com
```


### Create bucket for Terraform state.

```sh
gsutil mb -p ${TF_VAR_project} gs://${TF_VAR_project}-terraform-state
gsutil versioning set on gs://${TF_VAR_bucket}
```


### Initialise Terraform

```sh
cd ./infrastructure
terraform init -backend-config="bucket=$TF_VAR_bucket" -backend-config="credentials=$TF_VAR_credentials" -backend-config="project=$TF_VAR_project"
```


### Terraform Plan & Apply

First run `terraform plan` and check planned changes are correct. Next run
`terraform apply` to apply changes to the infrastructure.


## Configuration Management

Navigate to the `~/configure` directory and update variables in the
`./inventory/gcloud.gcp.yml` file.
