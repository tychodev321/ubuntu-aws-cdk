# https://hub.docker.com/_/ubuntu
FROM ubuntu:22.04

LABEL maintainer=""

ENV AWS_CDK_VERSION=2.51.1

ENV PYTHON_VERSION=3.10.10 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    PIP_NO_CACHE_DIR=off \
    POETRY_VERSION=1.2.2

ENV NODEJS_VERSION=18.0.0 \
    NPM_VERSION=10.1.0 \
    YARN_VERSION=1.22.19 \
    PATH=$HOME/.local/bin/:$PATH \
    npm_config_loglevel=warn \
    npm_config_unsafe_perm=true

# Install Base Tools
RUN apt update -y && apt upgrade -y \
    && apt install -y unzip \
    && apt install -y gzip \
    && apt install -y tar \
    && apt install -y wget \
    && apt install -y curl \
    && apt install -y git \
    && apt install -y sudo \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install Python
RUN apt update -y && apt upgrade -y \
    && apt install -y python3-pip \
    && apt install -y python3-venv \
    && apt install -y python3-setuptools \
    && apt install -y python-is-python3 \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/*

# Configure Python
ENV PATH=/root/.local/bin:$PATH

# Install pipx and poetry
RUN python -m pip install --user pipx \
    && python -m pipx ensurepath --force \
    && pipx install poetry==${POETRY_VERSION}

# Install Node and NPM
RUN apt update -y && apt upgrade -y \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - \
    && apt install -y nodejs \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install Yarn and AWS CDK
RUN npm install --global yarn@${YARN_VERSION} \
    && npm config set prefix /usr/local \
    && npm install -g aws-cdk@${AWS_CDK_VERSION}
    
RUN echo "cdk version: $(cdk --version)" \
    && echo "node version: $(node --version)" \
    && echo "npm version: $(npm --version)" \
    && echo "yarn version: $(yarn --version)" \
    && echo "python version: $(python --version)" \
    && echo "pip version - $(python -m pip --version)" \
    && echo "poetry about: $(poetry about)" \
    && echo "git version: $(git --version)"

# USER 1001

CMD ["echo", "This is a 'Purpose Built Image', It is not meant to be ran directly"]
