#!/bin/bash

aws s3 --profile=opensource cp s3://bugsnag-opensource-buildkite-secrets/platforms-infrastructure/.npmrc .
aws s3 --profile=opensource cp s3://bugsnag-opensource-buildkite-secrets/platforms-infrastructure/buildkite-agent.cfg .
aws s3 --profile=opensource cp s3://bugsnag-opensource-buildkite-secrets/platforms-infrastructure/environment .

mkdir -p expo
aws s3 --profile=opensource cp s3://bugsnag-opensource-buildkite-secrets/platforms-infrastructure/expo/Certificates.p12 expo
aws s3 --profile=opensource cp s3://bugsnag-opensource-buildkite-secrets/platforms-infrastructure/expo/Expotest.mobileprovision expo
