# GPU Development Server Docker Image

This Docker image sets up a GPU-enabled development server environment with SSH access, several development and system tools installed, and the option to use TUNA mirrors for faster downloads. 

## Prerequisites

- Docker 19.03 or later
- Git (optional, for cloning the repository)

## Building the Docker Image

1. Clone this repository (optional, if you haven't done so yet):

    ```bash
    git clone https://github.com/Outsider565/Docker_GPU_Dev_Server.git
    cd Docker_GPU_Dev_Server
    ```

2. Run the build script and provide the requested inputs. You can also just press enter to use the default values:

    ```bash
    chmod +x build.sh
    ./build.sh
    ```

    The build script prompts you for several ARG values to be used during the Docker build. The ARG values are:
    - LANG (default: en_US.UTF-8)
    - ADMIN_PASSWORD (default: "")
    - SSH_PUB_KEY (default: "")
    - SSH_AUTHORIZED_KEYS (default: "")
    - GOST_URL (default: `https://github.com/ginuerzh/gost/releases/download/v2.11.5/gost-linux-amd64-2.11.5.gz`)
    - GIT_USER_NAME (default: "")
    - GIT_USER_EMAIL (default: "")
    - USE_TUNA_MIRROR (default: true)
    - Docker image tag (default: outsider565/gpu_devdocker:test)

3. After running the script, Docker will build your image according to the Dockerfile and your inputs.

## Pulling the Docker Image

If you do not wish to build the image yourself, you can pull the pre-built image from Docker Hub:

```bash
docker pull outsider565/gpu_devdocker:tagname
```

## Running a Container from the Docker Image

To start a container from your Docker image, run the following command, replacing `<tag>` with the Docker image tag you chose when you built the image, and `<FORWARD_SERVER>` and `<FORWARD_PORT>` with your own forward server and port information:

Example:

```bash
docker run -d -e FORWARD_SERVER="<FORWARD_SERVER>" -e FORWARD_PORT="<FORWARD_PORT>" --gpus all outsider565/gpu_devdocker:<tag>
```

The `FORWARD_SERVER` should be deployed with [gost server](https://github.com/ginuerzh/gost), the format should be `IP:PORT`.
The `FORWARD_PORT` is the port you want to map the 22 port of the container to.

After running this command, you should be able to SSH into your container using the ADMIN_PASSWORD you set during the build, with the command:

```bash
ssh admin@<FORWARD_SERVER.IP> -p <FORWARD_PORT>
```

Please feel free to reach out with any issues or questions. You can refer to the Dockerfile for more information on the tools installed in the image.
