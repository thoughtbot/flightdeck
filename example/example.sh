#!/bin/bash

# Obtain this from: 
# https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-identifiers.html 
AWS_ACCOUNT_ID="ADDME"

# Available regions:
# https://aws.amazon.com/about-aws/global-infrastructure/regions_az/
AWS_REGION="ADDME"

# Only used if utilizing profiles in the AWS CLI.
AWS_PROFILE="ADDME"

# To create a private ECR repository: 
# https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-create.html 
AWS_ECR_NAME="flightdeck-example"

# Whatever you like.  In this script the same name is used for local and AWS; but they need not be the same.
CONTAINER_IMAGE="generic-app"

# If a tag is omitted, "latest" is used.  Tags must be unique, so this gives a simple way to create a Universal Unique Identifier (UUID).  
# https://man7.org/linux/man-pages/man1/uuidgen.1.html
UUID_TAG=$(uuidgen)

# This tag is only used locally.  It assumes container is re-built in place each time, but a UUID could be utilized here as well if keeping multiple iterations in local development (uncommon).
DEV_TAG="dev"

case "$1" in
    # Build from scratch (assumes at least multistage base is built).  Clean install if things get wonky.
    -b|--build)
        docker build --no-cache -t $CONTAINER_IMAGE:$DEV_TAG .
        ;;

    # Delete the container instance.
    -d|--delete)
        docker rmi -f $CONTAINER_IMAGE/$DEV_TAG
        ;;

    # Run the container locally.
    -r|--run)
        docker run -d -it --rm=true -p 80:80 $CONTAINER_IMAGE/$DEV_TAG
        ;;

    # Stop a running container.  Not typically needed with -rm=true
    -x|--exit)
        docker stop $(docker ps -q --filter ancestor=$CONTAINER_IMAGE/$DEV_TAG )
        ;;

    # Push the built container to an AWS Elastic Container Registry (ECR)
    -p|--push)
        # First, log in to ECR.  If not utilizing profiles in AWS CLI, --profile can be removed.
        # TODO: Explain when/why username and password flags are utilized.
        aws --profile $AWS_PROFILE ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
        
        # The container has been built and tagged with the DEV TAG.  This sets the tag on a copy of the container in the format that ECR expects.
        docker tag $CONTAINER_IMAGE:$DEV_TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$AWS_ECR_NAME:$UUID_TAG

        # Push the tagged continer from above to ECR utilizinag the UUID.
        docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$AWS_ECR_NAME:$UUID_TAG
        ;; 

    *)
        echo $"Usage: $0 { [b] build | [u] update | [d] delete | [r] run | [x] exit | [p] push }"
        exit 1
esac
