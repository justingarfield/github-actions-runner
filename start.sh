#!/bin/bash

REGISTRATION_TOKEN=$(curl -sX POST -H "Authorization: token ${PAT}" "https://api.github.com/orgs/${ORGANIZATION}/actions/runners/registration-token" | jq .token --raw-output)

cd /home/docker/actions-runner || exit

./config.sh \
  --url "https://github.com/${ORGANIZATION}" \
  --token "${REGISTRATION_TOKEN}" \
  --name "${NAME}" \
  --runnergroup "${RUNNER_GROUP}" \
  --labels "${LABELS}" \
  --work "${WORK}"

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token "${REG_TOKEN}"
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
