#!/bin/bash

read -p "Enter the Docker image tag [outsider565/gpu_devdocker:test]: " DOCKER_TAG
DOCKER_TAG=${DOCKER_TAG:-outsider565/gpu_devdocker:test}

read -p "Enter LANG [en_US.UTF-8]: " LANG
LANG=${LANG:-en_US.UTF-8}

read -p "Enter ADMIN_PASSWORD: " ADMIN_PASSWORD
ADMIN_PASSWORD=${ADMIN_PASSWORD:-""}

read -p "Enter SSH_PUB_KEY: " SSH_PUB_KEY
SSH_PUB_KEY=${SSH_PUB_KEY:-""}

read -p "Enter SSH_AUTHORIZED_KEYS: " SSH_AUTHORIZED_KEYS
SSH_AUTHORIZED_KEYS=${SSH_AUTHORIZED_KEYS:-""}

read -p "Enter GOST_URL [https://github.com/ginuerzh/gost/releases/download/v2.11.5/gost-linux-amd64-2.11.5.gz]: " GOST_URL
GOST_URL=${GOST_URL:-https://github.com/ginuerzh/gost/releases/download/v2.11.5/gost-linux-amd64-2.11.5.gz}

read -p "Enter GIT_USER_NAME: " GIT_USER_NAME
GIT_USER_NAME=${GIT_USER_NAME:-""}

read -p "Enter GIT_USER_EMAIL: " GIT_USER_EMAIL
GIT_USER_EMAIL=${GIT_USER_EMAIL:-""}

read -p "Enter USE_TUNA_MIRROR [true]: " USE_TUNA_MIRROR
USE_TUNA_MIRROR=${USE_TUNA_MIRROR:-true}

GOST_FILE=$(basename ${GOST_URL} .gz)

docker build . -t ${DOCKER_TAG} \
  --build-arg LANG=${LANG} \
  --build-arg ADMIN_PASSWORD=${ADMIN_PASSWORD} \
  --build-arg SSH_PUB_KEY="${SSH_PUB_KEY}" \
  --build-arg SSH_AUTHORIZED_KEYS="${SSH_AUTHORIZED_KEYS}" \
  --build-arg GOST_URL=${GOST_URL} \
  --build-arg GOST_FILE=${GOST_FILE} \
  --build-arg GIT_USER_NAME="${GIT_USER_NAME}" \
  --build-arg GIT_USER_EMAIL=${GIT_USER_EMAIL} \
  --build-arg USE_TUNA_MIRROR=${USE_TUNA_MIRROR}
