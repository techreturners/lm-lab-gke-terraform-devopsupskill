# GKE and Terraform

This repository shows examples and guides for using [Terraform](https://terraform.io) to provision a [GKE (Google Kubernetes Engine) Cluster](https://cloud.google.com/kubernetes-engine) on Google Cloud Platform

## Instructions

### Pre-requisites

You will need to ensure that you have installed terraform and the Google Cloud SDK (Command Line Interface) - as mentioned in the pre-session assignments  for DevOps up-skill session three.

### Step 1 - Install kubectl tool

The `kubectl` tool will be utilised to interact with your Kubernetes (K8S) cluster.

You can install this manually by following this guide below:

https://kubernetes.io/docs/tasks/tools/install-kubectl/

Or alternatively if you use a package manager it can be installed using the package manager:

**Homebrew**

```
brew install kubernetes-cli
```

**Chocolatey**

```
choco install kubernetes-cli
```

You can verify that it has installed correctly by running 

```
kubectl version
```

It should print something like the below:

```
Client Version: version.Info{Major:"1", Minor:"20", GitVersion:"v1.20.4", GitCommit:"e87da0bd6e03ec3fea7933c4b5263d151aafd07c", GitTreeState:"clean", BuildDate:"2021-02-21T20:21:49Z", GoVersion:"go1.15.8", Compiler:"gc", Platform:"darwin/amd64"}
```

Dont worry if it says "Unable to connect to server" at this stage. We'll be sorting that later.

### Step 2 - Explore the files

Before we go ahead and create your cluster its worth exploring the files.

**terraform.tfvars**

Think of this as the place where you define the actual values of variables to be used by your terraform configuration.

**vpc.tf**

This file contains the setup for the Virtual Private Cloud (VPC - remember those from session two) that your GKE will be placed into.

**gke.tf** 

Does the actual job of provisioning a GKE cluster and a separately managed node pool (recommended).

You'll also see that this file contains a variable called `gke_num_nodes` that is defaulted to 1. This means that one node will be created in each subnet. Totaling 3 nodes for your cluster.

**versions.tf** 

Configures the terraform providers (in our case the GCP provider) and sets the Terraform version to at least 0.14.

### Step 3 - Update the tfvars file

Now you know the files the next step is to update the tfvars file according to your project.

Update the project ID to be that of your Google Project ID and change the region if you would like it to be anything other than the UK.

### Step 4 - Update service account

In the terraform installation video you setup a service account. You'll need to re-use that service account again in order for Terraform to authenticate with your Google cloud account.

First **copy** the service account to this directory.

Then rename that service account file to be called **service-account.json** 

The reason for the rename is because you'll see it [mentioned in the **versions.tf**](./versions.tf) file and also in the **.gitignore** file. Choosing the name **service-account.json** will ensure you don't accidentally commit it due to us adding it to the gitignore file.

### Step 5 - Initialise terraform

We need to get terraform to pull down the google provider.

In order to do this run:

```
terraform init
```

You should see something similar to the below:

```
Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/google versions matching "3.58.0"...
- Installing hashicorp/google v3.58.0...
- Installed hashicorp/google v3.58.0 (signed by HashiCorp)
```

### Step 6 - Review changes with a plan

Firstly run a **plan** to see if what Terraform decides will happen.

```
terraform plan
```

### Step 7 - Create your cluster with apply

We can then create your cluster by apply the configuration.

**NOTE** If you find it complain that an API isn't enabled. [Compute Engine API](https://console.developers.google.com/apis/api/compute.googleapis.com/overview) and [Kubernetes Engine API](https://console.cloud.google.com/apis/api/container.googleapis.com/overview) are required for terraform apply to work on this configuration. Enable both APIs for your Google Cloud and then continue.

```
terraform apply
```

Sit back and relax - it might take 10 mins or so to create your cluster.

Once its done you'll have a your Kubernetes cluster all ready to go!!!

### Step 8 - Configure your **kube control** 

**kubectl** is used to issue actions on our cluster.

We need to configure **kubectl** to be able to authenticate with your cluster.



