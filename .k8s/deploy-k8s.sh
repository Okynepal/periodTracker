#!/bin/bash

# See /docs/deployment/build_tag_push_apply.md 

registry_url=""
version="latest"

echo '========================='
echo 'BUILD'
echo '========================='

docker-compose build --no-cache

echo '========================='
echo 'TAG'
echo '========================='

docker tag oky/base:latest $registry_url/base:$version
docker tag periodtracker-cms:latest $registry_url/cms:$version
docker tag periodtracker-api:latest $registry_url/api:$version

echo '========================='
echo 'PUSH'
echo '========================='

docker push $registry_url/base:$version
docker push $registry_url/cms:$version
docker push $registry_url/api:$version

echo '========================='
echo 'APPLY'
echo '========================='

kubectl apply -f .k8s/api-ingress.yaml
kubectl apply -f .k8s/cms-ingress.yaml
kubectl apply -f .k8s/api.yaml
kubectl apply -f .k8s/cms.yaml
