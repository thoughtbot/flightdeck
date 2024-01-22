## Flightdeck Getting Started Guide
This guide walks you through steps for deploying a minimal implementation of Flightdeck, a platform for managing Kubernetes applications.  This guide is not a full walk-through of everything needed to utilize Flightdeck, **and should not be considered ready for production** but rather enough of a start to become comfortable with deploying the rest of Flightdeck based on the [Flightdeck Platform Guide](https://thoughtbot.atlassian.net/wiki/spaces/APG/overview). 

### Prerequisites
Deploying Flightdeck has several crucial prerequisites such as setting up a 1Password account, selecting an Identity Provider for SSO, and leveraging AWS Control Tower for multi-account architecture.  In scope of this Getting Started Guide, many of these steps can be skipped, but there are a few which are still required:
* **AWS Account**: this can be done for free at [AWS Free-Tier Signup](https://aws.amazon.com/free/) or leverage an account already provided, utilizing whatever sign on and permissions are provided through the organization. 
* **AWS CLI**: Install configure AWS CLI following the [AWS Getting Started Guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html).
* **Development Tools**: Download and install [Terraform](https://developer.hashicorp.com/terraform/install) and [Docker](https://docs.docker.com/engine/install/) from their respective official website.
For more information on installing the full Flightdeck prerequisites, see the [Landing Zone](https://thoughtbot.atlassian.net/wiki/spaces/APG/pages/124977153/Landing+Zone) and [Install](https://thoughtbot.atlassian.net/wiki/spaces/APG/pages/11304961/Install) sections of the Platform Guide.

### Step 1: Deploy Flightdeck Kubernetes Clusters
Flightdeck requires Kubernetes clusters on AWS’s EKS platform:
* Cluster Configuration: Use Flightdeck's cluster Terraform module to set up compatible EKS clusters.  Follow the steps outlined in the [Makefile](https://github.com/thoughtbot/flightdeck/blob/christi-adding-getting-started/getting-started/Makefile), or simply run `make cluster` from this getting started-folder -- though it is always advised to read through any type of script before running it!

### Step 2 ~ n: TODO

### Step TODO: Deploy Example Application
TODO -- The example-app folder contains a Dockerfile describing implementation for an nginx server, an nginx.conf file, and a **Hello, World** HTML file.  Follow the steps in the `docker` command located in the [Makefile](https://github.com/thoughtbot/flightdeck/blob/christi-adding-getting-started/getting-started/Makefile), or simply run `make docker` from this getting-started folder. 

### Step TODO: Monitoring Setup
TODO -- Deploy Grafana: After deploying Flightdeck, proceed with deploying Grafana for effective monitoring of your infrastructure and applications.

### Conclusion
By following these steps, you'll have set up a minimal Kubernetes-based platform using Flightdeck. This guide provides a foundational approach, and you should adapt it to your specific organizational requirements and workflow.  Need more help, beyond the Platform Guide?  Please feel free to reach out to the [code owners](https://github.com/thoughtbot/flightdeck/blob/christi-adding-getting-started/CODEOWNERS), or consult with a [Thoughtbot Flightdeck Engineer](https://thoughtbot.com/hire-us) on how Flightdeck can be installed and maintained for your organization by seasoned professionals! 
