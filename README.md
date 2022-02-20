# GKE and Terraform

This repository shows examples and guides for using [Terraform](https://terraform.io) to provision a [GKE (Google Kubernetes Engine) Cluster](https://cloud.google.com/kubernetes-engine) on Google Cloud Platform

## Instructions

### Step 1 - Fork and clone

Fork this repository into your own GitHub account and then clone (your forked version) down to your local machine.

### Step 2 - Install and configure the GCloud SDK

We'll use the Google Command Line tool to get information from the cluster.

If you haven't already installed it then you can follow below to install.

To install this you can install manually by following [these instructions](https://cloud.google.com/sdk/docs/quickstarts) or if you have a package manager you can use the instructions below:

**Homebrew**

```
brew install --cask google-cloud-sdk
```

**Chocolatey**

```
choco install gcloudsdk
```

Once it is installed we need to configure it to point at your Google Cloud Project - to do this run:

```
gcloud init
```

When prompted ensure you pick the correct Google Cloud Project.

### Step 3 - Install kubectl tool

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

### Step 4 - Explore the files

Before we go ahead and create your cluster its worth exploring the files.

Oh and before we do explore, the files in this directory could have been named whatever we like. For example the **outputs.tf** file can have been called **foo.tf** - we just chose to call it that because it contained outputs. So the naming was more of a standard than a requirement.

**variables.tf**

This file contains the definitions of all the terraform [input variables](https://www.terraform.io/language/values/variables) we can set to drive your terraform execution.

**terraform.tfvars**

Think of this as the place where you define the actual values of variables to be used by your terraform configuration.

**vpc.tf**

This file contains the setup for the Virtual Private Cloud (VPC - remember those from session two) that your GKE will be placed into.

**gke.tf** 

Does the actual job of provisioning a GKE cluster and a separately managed node pool (recommended).

You'll also see that this file contains a variable called `gke_num_nodes` that is defaulted to 1. This means that one node will be created in each subnet. Totaling 3 nodes for your cluster.

**outputs.tf**

This file defines the outputs that will be produced by terraform when things have been provisioned.

**versions.tf** 

Configures the terraform providers (in our case the GCP provider) and sets the Terraform version to at least 0.14.

### Step 5 - Update the tfvars file

Now you know the files the next step is to update the tfvars file according to your project.

Update the project ID to be that of your Google Project ID and change the region if you would like it to be anything other than the UK.

### Step 6 - Update service account

In the terraform installation video you setup a service account. You'll need to re-use that service account again in order for Terraform to authenticate with your Google cloud account.

First **copy** the service account to this directory.

Then rename that service account file to be called **service-account.json** 

The reason for the rename is because you'll see it [mentioned in the **versions.tf**](./versions.tf) file and also in the **.gitignore** file. Choosing the name **service-account.json** will ensure you don't accidentally commit it due to us adding it to the gitignore file.

### Step 7 - Initialise terraform

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

### Step 8 - Review changes with a plan

Firstly run a **plan** to see if what Terraform decides will happen.

```
terraform plan
```

### Step 9 - Create your cluster with apply

We can then create your cluster by applying the configuration.

**NOTE** If you find that it errors stating that an API isn't enabled. [Compute Engine API](https://console.developers.google.com/apis/api/compute.googleapis.com/overview) and [Kubernetes Engine API](https://console.cloud.google.com/apis/api/container.googleapis.com/overview) are required for `terraform apply` to work on this configuration. Enable both APIs for your Google Cloud project and then continue.

```
terraform apply
```

Sit back and relax ☕️ - it might take 10 mins or so to create your cluster.

Once its finished it'll output something like the info below. 

Those **outputs** are defined in the **outputs.tf** file.

```
Outputs:

kubernetes_cluster_host = "35.246.22.132"
kubernetes_cluster_name = "devops-upskill-305410-gke"
project_id = "devops-upskill-305410"
region = "europe-west2"
```

Once its done you'll have your Kubernetes cluster all ready to go!!!

### Step 10 - Configure your **kube control** 

[kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) is used to issue actions on our cluster.

We need to configure **kubectl** to be able to authenticate with your cluster.

To do this we use the Google Cloud Command Line to get the credentials. Notice how we reference the outputs in the command below:


```
gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region)
```

It should say something like:

```
Fetching cluster endpoint and auth data.
kubeconfig entry generated for devops-upskill-305410-gke.
```

### Step 11 - Check if kubectl can access cluster

You can now verify if `kubectl` can access your cluster.

Go ahead and see how many nodes are running:

```
kubectl get nodes
```

It should show something like:

```
NAME                                                  STATUS   ROLES    AGE   VERSION
gke-devops-upskill-3-devops-upskill-3-6ab12de4-6p9p   Ready    <none>   18m   v1.18.12-gke.1210
gke-devops-upskill-3-devops-upskill-3-eada08f1-793v   Ready    <none>   18m   v1.18.12-gke.1210
gke-devops-upskill-3-devops-upskill-3-fa0c8ee0-j7qt   Ready    <none>   18m   v1.18.12-gke.1210
```

Exciting eh!!! 🚀

### Step 12 - Deploying your first app in a pod!!

Finally lets get a container running on your cluster.

Firstly check if there are any running pods

```
kubectl get pods
```

It should probably say something like this:

```
No resources found in default namespace.
```

Lets deploy the nginx deployment.

```
kubectl apply -f kubernetes/nginx-deployment.yaml
```

Now lets see the pods

```
kubectl get pods
```

And it will show something like this:

```
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-5cd5cdbcc4-b46m7   1/1     Running   0          14s
nginx-deployment-5cd5cdbcc4-knxss   1/1     Running   0          14s
nginx-deployment-5cd5cdbcc4-sqm2p   1/1     Running   0          14s
```

Actually you know what, I think 3 replicas is a bit overkill. Lets bring it down to 2 replicas.

Update the nginx-deployment.yaml file and change it down to 2 and save the file.

Then re-run your deployment.

```
kubectl apply -f kubernetes/nginx-deployment.yaml
```

Now lets see the pods

```
kubectl get pods
```

And you should see something like this:

```
NAME                                READY   STATUS        RESTARTS   AGE
nginx-deployment-5cd5cdbcc4-b46m7   1/1     Running       0          3m47s
nginx-deployment-5cd5cdbcc4-knxss   1/1     Running       0          3m47s
nginx-deployment-5cd5cdbcc4-sqm2p   0/1     Terminating   0          3m47s
```

### Step 13 - Exposing your webserver

Finally lets get that web server exposed to the internet with a **service**

We can do this by creating the service (which will sit in front of our pods) and the ingress point

Firstly create the service

```
kubectl apply -f kubernetes/nginx-service.yaml
```

And then create the ingress

```
kubectl apply -f kubernetes/nginx-ingress.yaml
```

Kubernetes will now create the required load balancer and create an external IP address for your ingress point.

Keep running the command below until you see an external IP address

```
kubectl get ing
```

It should output something like this:

```
NAME                      CLASS    HOSTS   ADDRESS         PORTS   AGE
nginx-webserver-ingress   <none>   *       34.117.49.187   80      95s
```

### Step 14 - Marvel at your creation

After around 5 to 10 mins you should be able to hit the endpoint with your browser. Using the example above I would go to: http://34.117.49.187

**NOTE** It does take around 5 to 10 mins and for some time you might see a Google 404 page.

**NOTE** Remember to check Google classroom before tearing things down. There are a couple of screenshots you should submit as evidence of your success 🙌

### Step 15 - Tearing down your cluster

Finally we want to destroy our cluster.

Firstly lets remove the service and ingress

```
kubectl delete -f kubernetes/nginx-ingress.yaml
kubectl delete -f kubernetes/nginx-service.yaml
```

Then we can destroy the cluster in full.

```
terraform destroy
```
