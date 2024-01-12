## Demo for Flightdeck

### Prerequisites
* Install Terraform: Download and install from Terraform's official website.
* Configure AWS CLI: Run aws configure for AWS credentials.

## First Steps
* To execute, run `terraform init` in your terminal to initialize the Terraform configuration.
* After successful initialization, run `terraform plan` to see the proposed changes.
* If everything looks good, run `terraform apply` to create the resources.

## Verify Cluster Creation:
* Check your new EKS cluster via AWS Console or kubectl get nodes.

## Deploy the Application
* Apply the deployment using kubectl apply -f hello-world-deployment.yaml.
* Verify with kubectl get deployments and kubectl get services.

