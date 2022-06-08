#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

# Syntax: ./node-install.sh <node version to install (use "none" to skip)> <directory to install nvm>
# https://github.com/microsoft/vscode-dev-containers/blob/master/containers/javascript-node/.devcontainer/library-scripts/node-debian.sh
set -e

export NODE_VERSION=${1:-"lts/*"}
export NVM_DIR=${2:-"/usr/local/share/nvm"}

if [ "$(id -u)" -ne 0 ]; then
    echo 'Script must be run a root. Use sudo or set "USER root" before running the script.'
    exit 1
fi

if [ "${NODE_VERSION}" = "none" ]; then
    export NODE_VERSION=
fi

if [ "$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d \")" = "Alpine Linux" ]; then
    # musl based nodejs build path
    # https://github.com/nvm-sh/nvm/issues/1102
    echo '
export NVM_NODEJS_ORG_MIRROR=https://unofficial-builds.nodejs.org/download/release
nvm_get_arch() { nvm_echo "x64-musl"; }' >> /root/.profile
    apk add --no-cache libstdc++
fi

mkdir -p ${NVM_DIR}
cat /usr/local/share/nvm-install.sh | NODE_VERSION= bash 2>&1
# Add NVM init and add code to update NVM ownership if UID/GID changes
tee -a /root/.zshrc >> /root/.bashrc \
<<EOF
source \$HOME/.profile
export NVM_DIR="${NVM_DIR}"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "\$NVM_DIR/bash_completion" ] && \\. "\$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOF

if [ "${NODE_VERSION}" != "" ]; then
    source ${NVM_DIR}/nvm.sh; source ${HOME}/.profile; nvm install ${NODE_VERSION}
fi

echo Install common build tools
source ${NVM_DIR}/nvm.sh && npm i -g yarn
source ${NVM_DIR}/nvm.sh && npm update -g
