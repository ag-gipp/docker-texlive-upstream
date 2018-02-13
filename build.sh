#!/bin/sh

if [ -e "./variables" ]; then
  source ./variables
fi

if git diff $LAST_COMMIT HEAD --name-only | grep *.$IMAGE_TAG; then
  docker build --pull -t "$CI_REGISTRY_IMAGE":$IMAGE_TAG -f Dockerfile.$IMAGE_TAG .
  docker push "$CI_REGISTRY_IMAGE":$IMAGE_TAG
  echo "REBUILD_ALL=true" >> variables
else
  if [ "$REBUILD_ALL" = "true" -o "$REBUILD_STAGE" = "$IMAGE_TAG" ]; then
    docker build --pull -t "$CI_REGISTRY_IMAGE":$IMAGE_TAG -f Dockerfile.$IMAGE_TAG .
    docker push "$CI_REGISTRY_IMAGE":$IMAGE_TAG
    echo "REBUILD_ALL=true" >> variables
  else
    echo "$IMAGE_TAG up to date, not building"
    echo "REBUILD_ALL=$REBUILD" >> variables
  fi
fi