#!/bin/bash

aws s3 --profile=opensource cp s3://bugsnag-opensource-buildkite-secrets/platforms-infra/.npmrc .
aws s3 --profile=opensource cp s3://bugsnag-opensource-buildkite-secrets/platforms-infra/buildkite-agent.cfg .
aws s3 --profile=opensource cp s3://bugsnag-opensource-buildkite-secrets/platforms-infra/environment .

mkdir -p expo
aws s3 --profile=opensource cp s3://bugsnag-opensource-buildkite-secrets/platforms-infra/expo/Certificates.p12 expo
aws s3 --profile=opensource cp s3://bugsnag-opensource-buildkite-secrets/platforms-infra/expo/Expotest.mobileprovision expo
