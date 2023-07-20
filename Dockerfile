# An easy-to-use development docker image
FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-devel

WORKDIR /root

USER root

# Use Tsinghua TUNA mirror if specified
RUN if [ "${USE_TUNA_MIRROR}" = "true" ]; then \
    mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list; \
    fi

RUN apt-get update && yes | unminimize && \
    apt-get install -y tldr vim htop tar zip net-tools man nvtop apt-utils git wget sudo rsync neovim nodejs iputils-ping curl mosh openssh-server locales zsh tmux && \
    locale-gen ${LANG} && \
    update-locale LANG=${LANG}

RUN GOST_FILE=$(basename $GOST_URL .gz) && \
    wget ${GOST_URL} && \
    gunzip ${GOST_FILE}.gz && \
    mv ${GOST_FILE} gost && \
    chmod +x gost && \
    cp gost /usr/local/bin/gost && \
    mkdir -p /var/run/sshd && chmod -R 755 /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    adduser admin --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password && \
    echo "admin:${ADMIN_PASSWORD}" | chpasswd && \
    sed -i 's/%admin ALL=(ALL) ALL/%admin ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers && \
    chsh -s $(which zsh) admin

USER admin

WORKDIR /home/admin

RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p /home/admin/miniconda && \
    rm -f miniconda.sh && \
    chown -R admin:admin /home/admin/miniconda && \
    export PATH="/home/admin/miniconda/bin:$PATH" && \
    conda init --all -v && \
    if [ "${USE_TUNA_MIRROR}" = "true" ]; then \
    echo "channels:\n  - defaults\nshow_channel_urls: true\ndefault_channels:\n  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main\n  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r\n  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2\ncustom_channels:\n  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n  pytorch-lts: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n  deepmodeling: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" > /home/admin/.condarc && \
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple; \
    fi && \
    conda install -y pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia && \
    pip install jupyterlab tqdm autopep8 ipdb matplotlib transformers tokenizers accelerate gradio datasets bitsandbytes nvitop

RUN sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" && \
    git clone https://github.com/gpakosz/.tmux.git && \
    ln -s -f .tmux/.tmux.conf && \
    cp .tmux/.tmux.conf.local . && \
    mkdir -p /home/admin/.ssh && \
    echo ${SSH_AUTHORIZED_KEYS} >> /home/admin/.ssh/authorized_keys && \
    echo ${SSH_PUB_KEY} >> /home/admin/.ssh/id_ed25519.pub && \
    chown -R admin:admin /home/admin/.ssh && \
    chmod -R 700 /home/admin/.ssh && \
    git config --global user.name ${GIT_USER_NAME} && \
    git config --global user.email ${GIT_USER_EMAIL} && \
    git clone https://github.com/wanhebin/clash-for-linux.git && \
    /home/admin/miniconda/bin/conda init --all -v

USER root
ENTRYPOINT service ssh start & /usr/local/bin/gost -L=rtcp://:${FORWARD_PORT}/:22 -F=socks5://${FORWARD_SERVER}
