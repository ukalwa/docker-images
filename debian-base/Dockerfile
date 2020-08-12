FROM mcr.microsoft.com/vscode/devcontainers/base:debian

ENV NONROOT_USER vscode
ENV DEBIAN_FRONTEND=noninteractive
# Add ZSH plugins
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions \
    && echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
# Install developer tools missing in the base image
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list | tee /etc/apt/sources.list.d/msprod.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y --no-install-recommends vim mssql-tools postgresql-client tmux \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' | tee -a /root/.bashrc /root/.zshrc /home/${NONROOT_USER}/.bashrc >> /home/${NONROOT_USER}/.zshrc
ENV DEBIAN_FRONTEND=dialog