#!/usr/bin/env bash

# Prerequisite
# Make sure you set secret enviroment variables: DOCKER_USERNAME and  DOCKER_PASSWORD in Travis CI

set -ex

Usage() {
  echo "$0 [rebuild]"
}

image="alpine/rancher-cli"
repo="rancher/cli"

latest=`curl -s https://api.github.com/repos/${repo}/tags |jq -r ".[].name"|head -1`
sum=0
echo "Lastest release is: ${latest}"

tags=`curl -s https://hub.docker.com/v2/repositories/${image}/tags/ |jq -r .results[].name`

for i in ${tags}
do
  if [ ${i} == ${latest} ];then
    sum=$((sum+1))
  fi
done

if [[ ( $sum -ne 1 ) || ( $1 == "rebuild" ) ]];then
  docker build --pull --no-cache --build-arg VERSION=${latest} -t ${image}:${latest} .
  status=`docker run --rm -it ${image}:${latest} rancher --version | sed 's/\\r//g' |awk 'NR==1{print $NF}'` 
  if [ "${status}" != "${latest}" ]; then 
    echo "unit test is failed."
    exit 1
  else
    echo "docker version matched."
    if [[ "$TRAVIS_BRANCH" == "master" ]]; then
      docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
      docker push ${image}:${latest}
    fi
  fi

fi
