#!/bin/bash

REPO=polysploit
IMAGE_NAME_BASE=polysploit

echo "$(date) Building binary..."
pv build go
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ] ; then
  echo "$(date) Failed to build $REPO binary."
  exit $EXIT_CODE
fi

echo "$(date) Obtaining current git sha for tagging the docker image"
headsha=$(git rev-parse --verify HEAD)

#First do the DockerHub repository
echo "--> Git sha is $headsha"
IMAGE_NAME=polyverse/$IMAGE_NAME_BASE:$headsha
echo "--> IMAGE_NAME is $IMAGE_NAME"

echo "$(date) Building a minimal docker image for $IMAGE_NAME_BASE tagged with $headsha..."
docker build -f Dockerfile -t $IMAGE_NAME .
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then
  echo "$(date) --> Docker build failed."
  exit $EXIT_CODE
fi

docker tag $IMAGE_NAME "polyverse/$IMAGE_NAME_BASE:latest"

echo "$(date) Pushing the new docker image to hub."
docker push $IMAGE_NAME
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ] ; then
  exit $EXIT_CODE
fi

docker push "polyverse/$IMAGE_NAME_BASE:latest"
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ] ; then
  exit $EXIT_CODE
fi

#Next do the jfrog repository
echo "--> Git sha is $headsha"
IMAGE_NAME=polyverse-tools.jfrog.io/$IMAGE_NAME_BASE:$headsha
echo "--> IMAGE_NAME is $IMAGE_NAME"

echo "$(date) Building a minimal docker image for $IMAGE_NAME_BASE tagged with $headsha..."
docker build -f Dockerfile -t $IMAGE_NAME .
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then
  echo "$(date) --> Docker build failed."
  exit $EXIT_CODE
fi

docker tag $IMAGE_NAME "polyverse-tools.jfrog.io/$IMAGE_NAME_BASE:latest"

echo "$(date) Pushing the new docker image to hub."
docker push $IMAGE_NAME
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ] ; then
  exit $EXIT_CODE
fi

docker push "polyverse-tools.jfrog.io/$IMAGE_NAME_BASE:latest"
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ] ; then
  exit $EXIT_CODE
fi

echo "$(date) Finished."
