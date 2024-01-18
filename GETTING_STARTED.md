# TODO -- Write a more cohesive overview. 
Deploying Flightdeck involves a series of steps, starting from setting up your AWS environment to deploying specific modules. Here's a high-level tutorial:

## Prerequisites
    AWS Account: Ensure you have an AWS account with appropriate permissions.
    Install Required Tools: Terraform, AWS CLI, and kubectl should be installed on your local machine.

# TODO -- these steps are an example of format.
## Step 1: Network Setup

    Deploy Network Module: Use the Flightdeck network module to set up your VPC, subnets, and other network-related configurations. This is a foundational step before deploying an EKS cluster.
        Module: Flightdeck provides a network module for this purpose.

Step 2: EKS Cluster Setup

    Create EKS Cluster: You'll need to manually set up an EKS cluster as Flightdeck does not provide a direct module for this.
        Module: Use a Terraform module from the Terraform Registry, such as terraform-aws-modules/eks/aws, for creating the EKS cluster.

Step 3: Deploying Flightdeck Modules

    Platform Setup: Once the network and EKS cluster are in place, use various Flightdeck modules to deploy and configure your Kubernetes environment.
        Modules: Flightdeck includes modules for different platform components (like ingress, monitoring, etc.). Deploy these modules as per your requirements.

Step 4: Application Deployment

    Deploy Applications: With your Kubernetes environment ready, you can now deploy your applications onto the cluster.

Post-Deployment

    Monitoring and Management: Set up monitoring and management tools as provided or recommended by Flightdeck modules.
    Security: Ensure all aspects of your deployment are secure and compliant with your organization's standards.

## Further Information
- [AWS](./aws/README.md)
- [Other](./platform/README.md)

