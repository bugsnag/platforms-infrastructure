#!/usr/bin/env sh

if [[ "$SERVER_TEST" == "11" ]]; then
  buildkite-agent pipeline upload .buildkite/macos-11.yml
  buildkite-agent pipeline upload .buildkite/build-test-fixtures.yml
elif [[ "$SERVER_TEST" == "10.15" ]]; then
  buildkite-agent pipeline upload .buildkite/macos-10.15.yml
  buildkite-agent pipeline upload .buildkite/build-test-fixtures.yml
elif [[ "$SERVER_TEST" == "10.14" ]]; then
  buildkite-agent pipeline upload .buildkite/macos-10.14.yml
elif [[ "$SERVER_TEST" == "10.13" ]]; then
  buildkite-agent pipeline upload .buildkite/macos-10.13.yml
else
  echo "SERVER_TEST not set to recognised value"
fi
