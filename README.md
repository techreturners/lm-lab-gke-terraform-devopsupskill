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

TBC

### Step 3 - Deploy and navigate ArgoCD

TBC

### Step 4 - Update your application and push new image

TBC

### Step 5 - Deploy the new version using a GitOps workflow

TBC
