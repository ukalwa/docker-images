FROM mcr.microsoft.com/vscode/devcontainers/javascript-node:0-12

# Get latest git
ENV GIT_VERSION 2.28.0
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

# Add ZSH plugins
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions \
    && echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
