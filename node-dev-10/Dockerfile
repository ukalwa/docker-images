FROM ukalwa/debian-base

ENV DEBIAN_FRONTEND=noninteractive
ENV NVM_DIR /usr/local/share/nvm
ENV NODE_VERSION 10.22.0
COPY ./node-debian.sh /usr/local/share
RUN /bin/sh /usr/local/share/node-debian.sh ${NVM_DIR} ${NODE_VERSION}
ENV PATH ${NVM_DIR}/versions/node/v${NODE_VERSION}/bin:${PATH}
ENV NODE_PATH ${NVM_DIR}/versions/node/v${NODE_VERSION}/lib/node_modules
ENV DEBIAN_FRONTEND=dialog
