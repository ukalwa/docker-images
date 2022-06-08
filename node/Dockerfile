ARG IMAGE=alpine
FROM ukalwa/${IMAGE}-base

ARG NODE_VERSION=lts/*
ENV NODE_VERSION ${NODE_VERSION}

COPY ./node-install.sh /usr/local/share/node-install.sh
COPY ./nvm-install.sh /usr/local/share/nvm-install.sh

RUN /bin/bash /usr/local/share/node-install.sh ${NODE_VERSION}