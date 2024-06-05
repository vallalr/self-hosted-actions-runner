#!/bin/bash

# Fetch the latest runner version from GitHub API
latest_version=$(curl --silent "https://api.github.com/repos/actions/runner/releases/latest" | jq -r .tag_name | cut -c 2-)

# Write the latest runner version to the .env file
echo "RUNNER_VERSION=$latest_version" > .env