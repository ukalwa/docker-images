FROM ukalwa/debian-base

ENV NODE_VERSION 12.22.1

ENV DEBIAN_FRONTEND=noninteractive
ENV NVM_DIR /usr/local/share/nvm
RUN /bin/bash /usr/local/share/node-install.sh ${NVM_DIR} ${NODE_VERSION}
ENV ENV $NVM_DIR/nvm.sh
ENV DEBIAN_FRONTEND=dialog
ENV PATH ${NVM_DIR}/versions/node/v${NODE_VERSION}/bin:${PATH}
ENV NODE_PATH ${NVM_DIR}/versions/node/v${NODE_VERSION}/lib/node_modules
