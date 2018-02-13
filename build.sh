#!/bin/sh

if [ -e "./variables" ]; then
  source ./variables
fi

BUILD_IT="false"

if git diff $LAST_COMMIT HEAD --name-only | grep *.$IMAGE_TAG; then
  BUILD_IT="true"
else
  if [ "$REBUILD_ALL" = "true" -o "$REBUILD_STAGE" = "$IMAGE_TAG" ]; then
    BUILD_IT="true"
  else
    echo "$IMAGE_TAG up to date, not building"
    echo "REBUILD_ALL=$REBUILD" >> variables
  fi
fi

if [ "$BUILD_IT" = "true" ]; then
  docker build --pull -t "$CI_REGISTRY_IMAGE:$IMAGE_TAG" -f "Dockerfile.$IMAGE_TAG" .
  docker push "$CI_REGISTRY_IMAGE:$IMAGE_TAG"
  echo "REBUILD_ALL=true" >> variables
  if [ "$LATEST" = "$IMAGE_TAG" ]; then
    docker tag "$CI_REGISTRY_IMAGE:$IMAGE_TAG" "$CI_REGISTRY_IMAGE:latest"
  fi
fi