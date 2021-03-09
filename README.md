# GKE and Terraform

This repository shows examples and guides for using [Terraform](https://terraform.io) to provision a [GKE (Google Kubernetes Engine) Cluster](https://cloud.google.com/kubernetes-engine) on Google Cloud Platform

## Instructions

Leading on from session 3 this repository provides instruction for both provisioning your cluster, pushing docker images to your own container registry and adopting a GitOps workflow using ArgoCD

### Step 1 - Provision your cluster

You have probably destroyed your Kubernetes cluster following the previous session. 

Follow through the [Provisioning](./docs/PROVISIONING.md) guide to re-provision your Kubernetes cluster.

The Terraform files have also been updated to include the creation of a container registry.

For those interested in the terraform changes, you can see a diff of what has changed since session 3 here:

[https://github.com/techreturners/devops-upskill-gke-terraform/compare/session-004-gitops](https://github.com/techreturners/devops-upskill-gke-terraform/compare/session-004-gitops)

### Step 2 - Build and push your docker image

The next step is to build the docker image locally and push it up to your newly created container registry.

Follow through the [Pushing Image Guide](./docs/PUSHINGIMAGE.md) for instructions on how to do this.

### Step 3 - Deploy and navigate to ArgoCD

Now you can move on to getting the backend API Python app deployed via Argo.

Follow through the [Argo setup and configuration steps](./docs/ARGO.md)

### Step 4 - Update your application and push new image

Using what we've covered so far, try and update the backend Python App to include some new books.

Build the docker image and push a new version (remember that tagging) to your container registry.

### Step 5 - Deploy the new version using a GitOps workflow

TBC
