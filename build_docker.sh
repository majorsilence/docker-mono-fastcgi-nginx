#!/bin/bash
set -e # exit on first error
set -u # exit on using unset variable

echo "Building majorsilence/docker-mono-fastcgi-nginx:latest"
docker build --progress plain -f ./Dockerfile -t majorsilence/docker-mono-fastcgi-nginx .
echo 'majorsilence/docker-mono-fastcgi-nginx:latest built'

GITHASH="$(git rev-parse --short HEAD)"

echo 'Tagging latest'
docker tag majorsilence/docker-mono-fastcgi-nginx majorsilence/docker-mono-fastcgi-nginx:latest
echo "Tagging $GITHASH"
docker tag majorsilence/docker-mono-fastcgi-nginx majorsilence/docker-mono-fastcgi-nginx:$GITHASH

echo 'Pushing'
docker push majorsilence/docker-mono-fastcgi-nginx:latest
docker push majorsilence/docker-mono-fastcgi-nginx:$GITHASH
