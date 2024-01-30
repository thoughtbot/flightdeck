## Overview
The Flightdeck platform is a containerized runtime environment built on top of popular cloud services including security, CI/CD, and scalability features.  Deploying the Flightdeck platform involves a series of steps as prerequisites, as well as steps to deploy the platform itself.  This guide walks through the end-to-end vanilla deployment.

For new or existing projects, especially ones that have PII data (think health and financial services) Flightdeck provides a powerful, enterprise ready platform to begin building or migrating enterprise-grade applications.  Flightdeck has already been used for many in education, health, and financial industries just to name a few.

This guide walks through a linear process of deployment based on the [AWS Platform Guide](https://thoughtbot.atlassian.net/wiki/spaces/APG/overview).  It is highly recommended to read through each relevant section to understand the nuances of the steps this tutorial outlines.

## Steps
* Create email groups for AWS root users.
* Create management AWS account (e.g. aws-management@example.com).
* Create Email addresses for root users of AWS accounts, for example:
    * aws-identity@example.com
    * aws-audit@example.com
    * aws-backup@example.com
    * aws-report@example.com
    * aws-log-archive@example.com
    * aws-network@example.com
    * aws-operations@example.com
    * aws-sandbox@example.com
    * aws-production@example.com
    * sso-management@example.com
* Create email groups for permission sets.
    * Google
        * Google login for each developer working on the platform
        * Set up SAML
        * Set up SCIM
        * Google Groups for permission sets:
            * aws-production-developers
            * aws-production-secrets
            * aws-production-viewers
            * aws-sandbox-developers
            * aws-sandbox-secrets
            * aws-sandbox-viewers
    * Microsoft
        * ActiveDirectory login for each developer working on the platform
        * Set up the Microsoft SSO app
        * ActiveDirectory security groups for permission sets:
            * aws-production-developers
            * aws-production-secrets
            * aws-production-viewers
            * aws-sandbox-developers
            * aws-sandbox-secrets
            * aws-sandbox-viewers
* Create source code repositories -- for details on the repos needed, see [Repository Conventions](https://thoughtbot.atlassian.net/wiki/spaces/APG/pages/10649919).
* Create password vault (e.g. 1Password or similar).
* Register or delegate domains.
* [Launch Control Tower](https://thoughtbot.atlassian.net/wiki/spaces/APG/pages/11239471).
* [Launch Customizations for Control Tower](https://thoughtbot.atlassian.net/wiki/spaces/APG/pages/86999041).
* [Set up accounts](https://thoughtbot.atlassian.net/wiki/spaces/APG/pages/11173895).
* [Configure Single Sign On](https://thoughtbot.atlassian.net/wiki/spaces/APG/pages/86933512).
* Configure DNS for domains.
    * If a domain name already exists:
        * Prefer that DNS be transferred to Route 53 in the network account.
        * If can’t be transferred, determine if Terraform access can be set up for IAC.
    * If no domain exists:
        * Register a new domain through Route 53 in the network account.
* Continuous Integration and Deployment (CI/CD) for infrastructure
* [Provision Platform Resources](https://thoughtbot.atlassian.net/wiki/spaces/APG/pages/11304961/Install).
* Create users for developers.
* Define infrastructure for first application.
* Implement CI/CD for first application.
* Define SLO agreement.
* Define high level policies for security and compliance.
* Discuss backup and disaster recovery plan.
* Implement SRE infrastructure.
* Implement automated policies for security and compliance.
* Implement centralized backup and recovery.

## Details

### Platform Dependencies
The Landing Zone is the start URL for users to access the organization's AWS accounts.

Flightdeck uses [Control Tower](https://aws.amazon.com/controltower/) to build a Landing Zone implementing security best practices and reliable workload isolation. This provides a quick starting point for a multi-account setup while still allowing for significant customization and expansion later.
Rather than managing individual IAM users, it is suggested to use [AWS SSO](https://aws.amazon.com/single-sign-on/) to manage users centrally and integrate with existing identity stores like a Google or Microsoft user directory.

Flightdeck also uses [Customizations for Control Tower](https://aws.amazon.com/solutions/implementations/customizations-for-aws-control-tower/) to configure [account baselines](https://docs.aws.amazon.com/controltower/latest/userguide/terminology.html) and deploy [service control policies](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps.html).
 
### Accounts and Network
In order to fully deploy the Flightdeck platform, it is recommended to set up the [conventional accounts](https://thoughtbot.atlassian.net/wiki/spaces/APG/pages/10649900) in addition to the standard accounts using the [landing zone repository template](https://thoughtbot.atlassian.net/wiki/spaces/APG/pages/14680065). It may take some time for all the required accounts to be provisioned. Once all the accounts are fully enrolled, next step is to create [VPC networks](https://thoughtbot.atlassian.net/wiki/spaces/APG/pages/11304982).
In the [infrastructure repository](https://thoughtbot.atlassian.net/wiki/spaces/APG/pages/10649919) for the organization create Terraform root modules for managing VPCs and related networking resources. Diagrams of the network and account structure can be provided to security teams for compliance framework purposes.

### Ingress Stack
In the [infrastructure repository](https://thoughtbot.atlassian.net/wiki/spaces/APG/pages/13599104) for the organization, you can create Terraform root modules for managing ingress resources, including hosted zones, SSL certificates, load balancers, target groups, and DNS aliases. In order to provision the ingress stack, at least one hosted zone is required. For more information on configuring hosted zones see [DNS administration](https://thoughtbot.atlassian.net/wiki/spaces/APG/pages/11173932).

Flightdeck includes a [Terraform module](https://thoughtbot.atlassian.net/wiki/spaces/APG/pages/14450709) for provisioning an entire ingress stack, including:
* An [application load balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html) for handling incoming requests.
* An [ACM certificate](https://docs.aws.amazon.com/acm/latest/userguide/acm-overview.html) for encrypting requests using TLS.
* A [Route 53 alias](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-choosing-alias-non-alias.html) to publish a DNS address for the load balancer.
* [Target groups](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html) for the clusters in this ingress stack.

### Flightdeck Platform
Flightdeck is a platform for deploying and managing applications on Kubernetes. Flightdeck consists of Terraform modules for deploying a curated set of preconfigured open source projects and AWS products.

In order to deploy Flightdeck, you'll first need Kubernetes clusters. On AWS, Flightdeck is designed to deploy to AWS's EKS platform. Flightdeck contains a [cluster Terraform module](https://thoughtbot.atlassian.net/wiki/spaces/APG/pages/14680073) capable of setting up compatible EKS clusters.
Create a root module for each phase of the software development lifecycle to deploy an [EKS cluster](https://docs.aws.amazon.com/eks/latest/userguide/clusters.html) and [managed node groups](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html).
Finally, deploy Flightdeck for the sandbox and production clusters using the [workload platform module](https://thoughtbot.atlassian.net/wiki/spaces/APG/pages/14680081).

### Monitoring Set Up
[Grafana](https://grafana.com/) is recommended to monitor infrastructure and applications. AWS's managed services can be leveraged for deploying centralized Prometheus and Grafana instances. Flightdeck can forward time series data from its federated Prometheus instance to an AWS Managed Prometheus instance for long-term storage. This instance can also be used as a data source for AWS Managed Grafana.

## Further Platform Information
- [AWS](./aws/README.md)
- [Other](./platform/README.md)

