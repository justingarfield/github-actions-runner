# base
FROM ubuntu:22.04

# set the github runner version
ARG RUNNER_VERSION="2.294.0"

# update the base packages and add a non-sudo user
RUN apt-get update && apt-get upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
   ca-certificates=20211016 \
   curl=7.81.0 \
   ansible-core=2.12.0 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && useradd -m docker

WORKDIR /home/docker

# cd into the user directory, download and unzip the github actions runner
RUN mkdir actions-runner 

WORKDIR /home/docker/actions-runner

RUN curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# install some additional dependencies
RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

# copy over the start.sh script
COPY start.sh start.sh

# make the script executable
RUN chmod +x start.sh

# since the config and run script for actions are not allowed to be run by root,
# set the user to "docker" so all subsequent commands are run as the docker user
USER docker

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start.sh"]
