#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

# Syntax: ./node-alpine.sh <directory to install nvm> <node version to install (use "none" to skip)> <non-root user>
# https://github.com/microsoft/vscode-dev-containers/blob/master/containers/javascript-node/.devcontainer/library-scripts/node-debian.sh
set -e

export NVM_DIR=${1:-"/usr/local/share/nvm"}
export NODE_VERSION=${2:-"lts/*"}
NONROOT_USER=${3:-"vscode"}

if [ "$(id -u)" -ne 0 ]; then
    echo 'Script must be run a root. Use sudo or set "USER root" before running the script.'
    exit 1
fi

if [ "${NODE_VERSION}" = "none" ]; then
    export NODE_VERSION=
fi

# musl based nodejs build path
# https://github.com/nvm-sh/nvm/issues/1102
tee -a /home/${NONROOT_USER}/.profile >> /root/.profile \
<< EOF
export NVM_NODEJS_ORG_MIRROR=https://unofficial-builds.nodejs.org/download/release
nvm_get_arch() { nvm_echo "x64-musl"; }
EOF

# Install NVM
apk add --no-cache libstdc++
mkdir -p ${NVM_DIR}
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | NODE_VERSION= bash 2>&1
# Add NVM init and add code to update NVM ownership if UID/GID changes
if [ "${NONROOT_USER}" != "root" ] && id -u $NONROOT_USER > /dev/null 2>&1; then
    # Add NVM init and add code to update NVM ownership if UID/GID changes
    tee -a /root/.zshrc /home/${NONROOT_USER}/.zshrc >> /home/${NONROOT_USER}/.bashrc \
<<EOF
source \$HOME/.profile
export NVM_DIR="${NVM_DIR}"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "\$NVM_DIR/bash_completion" ] && \\. "\$NVM_DIR/bash_completion"  # This loads nvm bash_completion
if [ "\$(stat -c '%U' \$NVM_DIR)" != "${NONROOT_USER}" ]; then
    sudo chown -R ${NONROOT_USER}:root \$NVM_DIR
fi
EOF

    if [ "${NODE_VERSION}" != "" ]; then
        source ${NVM_DIR}/nvm.sh; source ${HOME}/.profile; nvm install ${NODE_VERSION}
    fi
    
    # Update ownership
    chown ${NONROOT_USER} ${NVM_DIR} /home/${NONROOT_USER}/.bashrc /home/${NONROOT_USER}/.zshrc
fi

# Install yarn
source ${NVM_DIR}/nvm.sh && npm i -g yarn
