#!/usr/bin/env bash

DOCKER_CMD="docker run -it --rm --network host --ipc=host --mount src=$(pwd),target=/root/code/stable-baselines,type=bind"
DOCKER_IMAGE="araffin/stable-baselines-cpu:v2.7.0"
BASH_CMD="cd /root/code/stable-baselines/ && pip install tensorflow==1.5.0 gym==0.14.0"

# For pull requests from fork, Codacy token is not available, leading to build failure
if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
  ${DOCKER_CMD} ${DOCKER_IMAGE} \
      bash -c "${BASH_CMD} && \
               pytest --cov-config .coveragerc --cov-report term --cov=. -v tests/"
else
  ${DOCKER_CMD} --env CODACY_PROJECT_TOKEN=$CODACY_PROJECT_TOKEN ${DOCKER_IMAGE} \
      bash -c "${BASH_CMD} && \
                pytest --cov-config .coveragerc --cov-report term --cov-report xml --cov=. -v tests/ && \
                python-codacy-coverage -r coverage.xml --token=$CODACY_PROJECT_TOKEN"
fi
