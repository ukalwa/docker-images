FROM mcr.microsoft.com/vscode/devcontainers/python:0-3.7

ENV PYTHONUNBUFFERED 1

# Get latest git
ENV GIT_VERSION 2.28.0
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y dh-autoreconf libcurl4-gnutls-dev libexpat1-dev \
    gettext libz-dev libssl-dev \
    && curl https://mirrors.edge.kernel.org/pub/software/scm/git/git-${GIT_VERSION}.tar.gz -o /tmp/git-${GIT_VERSION}.tar.gz \
    && cd /tmp && tar -zxf /tmp/git-${GIT_VERSION}.tar.gz && cd git-${GIT_VERSION} \
    && make configure && ./configure --prefix=/usr && make all \
    && make install \
    # Clean up
    && apt-get remove -y dh-autoreconf libcurl4-gnutls-dev libexpat1-dev \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/${GIT_VERSION}*

# Install developer tools missing in the base image
RUN apt-get update \
    && apt-get install -y vim \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Add ZSH plugins
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions \
    && echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
ENV DEBIAN_FRONTEND=dialog