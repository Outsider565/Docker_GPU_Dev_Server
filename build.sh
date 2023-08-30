#!/bin/bash

read -p "Enter the pytorch image tag, e.g. 2.0.1-cuda11.7-cudnn8-devel: " PYTORCH_TAG
if [ -z "${PYTORCH_TAG}" ]; then
  echo "PYTORCH_TAG is empty, quit."
  exit 1
fi

read -p "Enter the Docker image tag [outsider565/gpu_devdocker:${PYTORCH_TAG}]: " DOCKER_TAG
DOCKER_TAG=${DOCKER_TAG:-outsider565/gpu_devdocker:${PYTORCH_TAG}}

read -p "Enter LANG [en_US.UTF-8]: " LANG
LANG=${LANG:-en_US.UTF-8}

read -p "Enter ADMIN_PASSWORD [testadminpassword]: " ADMIN_PASSWORD
ADMIN_PASSWORD=${ADMIN_PASSWORD:-testadminpassword}

read -p "Enter GOST_URL [https://github.com/ginuerzh/gost/releases/download/v2.11.5/gost-linux-amd64-2.11.5.gz]: " GOST_URL
GOST_URL=${GOST_URL:-https://github.com/ginuerzh/gost/releases/download/v2.11.5/gost-linux-amd64-2.11.5.gz}

read -p "Enter GIT_USER_NAME: " GIT_USER_NAME
GIT_USER_NAME=${GIT_USER_NAME:-""}

read -p "Enter GIT_USER_EMAIL: " GIT_USER_EMAIL
GIT_USER_EMAIL=${GIT_USER_EMAIL:-""}

read -p "Enter USE_TUNA_MIRROR [true]: " USE_TUNA_MIRROR
USE_TUNA_MIRROR=${USE_TUNA_MIRROR:-"true"}

read -p "Enter Ubuntu version, if 22.04->jammy, if 20.04->focal [focal]: " UBUNTU_VERSION
UBUNTU_VERSION=${UBUNTU_VERSION:-focal}


GOST_FILE=$(basename ${GOST_URL} .gz)

echo "build command: \
docker build . -t ${DOCKER_TAG} \
  --build-arg PYTORCH_TAG=${PYTORCH_TAG} \
  --build-arg LANG=${LANG} \
  --build-arg ADMIN_PASSWORD=${ADMIN_PASSWORD} \
  --build-arg GOST_URL=${GOST_URL} \
  --build-arg GOST_FILE=${GOST_FILE} \
  --build-arg GIT_USER_NAME="${GIT_USER_NAME}" \
  --build-arg GIT_USER_EMAIL=${GIT_USER_EMAIL} \
  --build-arg USE_TUNA_MIRROR=${USE_TUNA_MIRROR} \
  --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} \
  --network host"

docker build . -t ${DOCKER_TAG} \
  --build-arg PYTORCH_TAG=${PYTORCH_TAG} \
  --build-arg LANG=${LANG} \
  --build-arg ADMIN_PASSWORD=${ADMIN_PASSWORD} \
  --build-arg GOST_URL=${GOST_URL} \
  --build-arg GOST_FILE=${GOST_FILE} \
  --build-arg GIT_USER_NAME="${GIT_USER_NAME}" \
  --build-arg GIT_USER_EMAIL=${GIT_USER_EMAIL} \
  --build-arg USE_TUNA_MIRROR=${USE_TUNA_MIRROR} \
  --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} \
  --network host
