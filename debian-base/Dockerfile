FROM mcr.microsoft.com/vscode/devcontainers/base:debian

ENV NONROOT_USER vscode
ENV DEBIAN_FRONTEND=noninteractive

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
ENV DEBIAN_FRONTEND=dialog
COPY ./node-debian.sh /usr/local/share/node-install.sh
COPY ./nvm-install.sh /usr/local/share/nvm-install.sh