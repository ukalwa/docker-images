FROM ukalwa/debian-base

ENV NODE_VERSION 12

ENV DEBIAN_FRONTEND=noninteractive
ENV NVM_DIR /usr/local/share/nvm
RUN /bin/bash /usr/local/share/node-install.sh ${NVM_DIR} ${NODE_VERSION}
ENV ENV $NVM_DIR/nvm.sh
ENV DEBIAN_FRONTEND=dialog
