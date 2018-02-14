#!/bin/sh

if [ -e "./variables" ]; then
  echo "Sourcing variables from previous stage"
  source ./variables
else
  echo "No variables available. I'm not sourcing anything"
fi

BUILD_IT="false"

if git diff $LAST_COMMIT HEAD --name-only | grep "$IMAGE_TAG.Dockerfile"; then
  echo "Building $IMAGE_TAG since it changed from commit $LAST_COMMIT"
  BUILD_IT="true"
elif [ "$REBUILD_ALL" = "true" ]; then
  echo "Building $IMAGE_TAG from rebuild all request"
  BUILD_IT="true"
elif [ "$REBUILD_STAGE" = "$IMAGE_TAG" ]; then
  echo "Building $IMAGE_TAG from rebuild image stage request"
  BUILD_IT="true"
else
  echo "$IMAGE_TAG up to date, not building it"
fi

if [ "$BUILD_IT" = "true" ]; then
  docker build --pull -t "$CI_REGISTRY_IMAGE:$IMAGE_TAG" -f "$IMAGE_TAG.Dockerfile" .
  docker push "$CI_REGISTRY_IMAGE:$IMAGE_TAG"
  echo "Marking all future stages for rebuild"
  echo "REBUILD_ALL=true" >> variables
  if [ "$LATEST" = "$IMAGE_TAG" ]; then
    echo "Pushing $IMAGE_TAG as latest too"
    docker tag "$CI_REGISTRY_IMAGE:$IMAGE_TAG" "$CI_REGISTRY_IMAGE:latest"
    docker push "$CI_REGISTRY_IMAGE:latest"
  fi
fi