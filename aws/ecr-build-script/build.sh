#!/bin/sh

set -e

AWS_ECR_ACCOUNT_URL="${account_id}.dkr.ecr.${aws_region}.amazonaws.com"
echo "Logging into ECR..."
aws ecr get-login-password --region "${aws_region}" \
  | docker login \
    --username AWS \
    --password-stdin "$AWS_ECR_ACCOUNT_URL"

pullbase() {
  echo "$REPOSITORY:$1" >&2
  docker pull "$REPOSITORY:$1" > /dev/null 2>&1 &&
    echo "$REPOSITORY:$1"
}

set -x

COMMIT=$(git rev-parse --short HEAD)
BASE=$(git rev-parse --short "$(echo "$3" | sed 's|.*/||')")
BASE_IMAGE_NAME="${base_image}"
BRANCH=$(echo "$1" | sed 's|.*/||')
REPOSITORY_NAME="${repository_name}"
REPOSITORY="$AWS_ECR_ACCOUNT_URL/$REPOSITORY_NAME"
BASE_IMAGE_TAG=$(echo "$BASE_IMAGE_NAME" | cut -d: -f2)
BASE_IMAGE_MIRROR="$AWS_ECR_ACCOUNT_URL/$REPOSITORY_NAME-base:$BASE_IMAGE_TAG"

# Pulling base image...
if ! docker pull "$BASE_IMAGE_MIRROR"; then
  docker pull "$BASE_IMAGE_NAME"
  docker tag "$BASE_IMAGE_NAME" "$BASE_IMAGE_MIRROR"
  docker push "$BASE_IMAGE_MIRROR"
fi

# Pulling builder image...
builderbase=$(pullbase "$COMMIT-builder" \
  || pullbase "$BASE-builder" \
  || echo scratch)

# Building builder target...
docker build \
  --tag app:builder \
  --cache-from "$builderbase" \
  --target "builder" \
  --file "${dockerfile}" \
  --build-arg BASE_IMAGE="$BASE_IMAGE_MIRROR" \
  ${build_args} .

# Checking for existing builder image...
if ! docker pull "$REPOSITORY:$COMMIT-builder"; then
  # Pushing builder image...
  docker tag app:builder "$REPOSITORY:$COMMIT-builder"
  docker push "$REPOSITORY:$COMMIT-builder"
fi

# Pulling final image...
finalbase=$(pullbase "$COMMIT" \
  || pullbase "$BASE" \
  || echo scratch)

# Building final target...
docker build \
  --cache-from "app:builder" \
  --cache-from "$finalbase" \
  --file "${dockerfile}" \
  --tag app:release \
  --build-arg BASE_IMAGE="$BASE_IMAGE_MIRROR" \
  ${build_args} .

# Checking for existing image...
if ! docker pull "$REPOSITORY:$COMMIT"; then
  # Pushing final image...
  docker tag app:release "$REPOSITORY:$COMMIT"
  docker push "$REPOSITORY:$COMMIT"
fi

if [ -n "$BRANCH" ]; then
  if ! docker pull "$REPOSITORY:$BRANCH-$COMMIT"; then
    # Pushing branch image...
    docker tag app:release "$REPOSITORY:$BRANCH-$COMMIT"
    docker push "$REPOSITORY:$BRANCH-$COMMIT"
  fi
fi
