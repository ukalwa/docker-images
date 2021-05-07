FROM mcr.microsoft.com/vscode/devcontainers/python:0-3.8

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
    
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list | tee /etc/apt/sources.list.d/msprod.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y --no-install-recommends mssql-tools unixodbc-dev postgresql-client vim tmux\
    # Fix sql server connection issues due to SSL security levels
    && chmod +rwx /etc/ssl/openssl.cnf \
    && sed -i 's/TLSv1.2/TLSv1/g' /etc/ssl/openssl.cnf \
    && sed -i 's/SECLEVEL=2/SECLEVEL=1/g' /etc/ssl/openssl.cnf \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' | tee -a /root/.bashrc /root/.zshrc /home/${NONROOT_USER}/.bashrc >> /home/${NONROOT_USER}/.zshrc


# Add ZSH plugins
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions \
    && echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
ENV DEBIAN_FRONTEND=dialog
