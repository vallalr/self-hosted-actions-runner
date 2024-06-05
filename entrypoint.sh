#!/bin/bash

ORGANIZATION=${ORGANIZATION}

ACCESS_TOKEN=${ACCESS_TOKEN}

RUNNER_NAME=${RUNNER_NAME:-${RUNNER_NAME_PREFIX:-github-runner}-$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '')}
RUNNER_WORKDIR=${RUNNER_WORKDIR:-/_work}
LABELS=${LABELS:-default}
RUNNER_GROUP=${RUNNER_GROUP:-Default}
GITHUB_HOST=${GITHUB_HOST:="github.com"}

if [ -z ${ACCESS_TOKEN+x} ]; then
  echo "ACCESS_TOKEN environment variable is not set"
  exit 1
fi

if [ -z ${ORGANIZATION+x} ]; then
  echo "ORGANIZATION environment variable is not set."
  exit 1
fi

REG_TOKEN=$(curl -sX POST -H "Authorization: token ${ACCESS_TOKEN}" https://api.github.com/orgs/${ORGANIZATION}/actions/runners/registration-token | jq .token --raw-output)

/gh-runner/config.sh --url https://github.com/${ORGANIZATION} --token ${REG_TOKEN} --name ${RUNNER_NAME} --work ${RUNNER_WORKDIR} --labels ${LABELS} --runnergroup ${RUNNER_GROUP}

cleanup() {
    echo "Removing runner..."
    /gh-runner/config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

/gh-runner/run.sh & wait $!