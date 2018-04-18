# rancher cli
Auto-trigger docker build for [rancher cli](https://github.com/rancher/cli) when new release is announced

### Repo:

https://github.com/alpine-docker/rancher-cli

### Daily build logs:

https://travis-ci.org/alpine-docker/rancher-cli

### Docker iamge tags:

https://hub.docker.com/r/alpine/rancher-cli/tags/

# Usage:

    # must mount the local folder to /apps in container.
    docker run -ti --rm -v $(pwd):/apps alpine/rancher-cli:v0.6.9 rancher --help
    
    docker run -i -v $(pwd):/apps \
	  -e "RANCHER_URL=${RANCHER_URL}" \
	  -e "RANCHER_ACCESS_KEY=${RANCHER_ACCESS_KEY}" \
	  -e "RANCHER_SECRET_KEY=${RANCHER_SECRET_KEY}" \
	  alpine/rancher:v0.6.9 \
	  sh -c "rancher ps"

# The Processes to build this image

* Enable Travis CI cronjob on this repo to run build daily on master branch
* Check if there are new tags/releases announced via Github REST API
* Match the exist docker image tags via Hub.docker.io REST API
* If not matched, build the image with latest version as tag and push to hub.docker.com
* Versions old than 0.0.6.8 were manually built and pushed.
