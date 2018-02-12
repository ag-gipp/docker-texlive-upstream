#!/bin/sh

if git diff $LAST_COMMIT HEAD --name-only | grep *.$IMAGE_TAG; then
  docker build --pull -t "$CI_REGISTRY_IMAGE":$IMAGE_TAG - < Dockerfile.$IMAGE_TAG
  docker push "$CI_REGISTRY_IMAGE":$IMAGE_TAG
  echo "REBUILD=true" >> variables
else
  if [ "$REBUILD" = "true" ]; then
    docker build --pull -t "$CI_REGISTRY_IMAGE":$IMAGE_TAG - < Dockerfile.$IMAGE_TAG
    docker push "$CI_REGISTRY_IMAGE":$IMAGE_TAG
    echo "REBUILD=true" >> variables
  else
    echo "$IMAGE_TAG up to date, not building"
    echo "REBUILD=$REBUILD" >> variables
  fi
fi