ARG IMAGE=alpine
FROM ukalwa/${IMAGE}-base

ENV PYTHONUNBUFFERED=1 \
   PYTHONDONTWRITEBYTECODE=1 \
   PIP_DEFAULT_TIMEOUT=100 \
   PIP_DISABLE_PIP_VERSION_CHECK=1 \
   PIP_NO_CACHE_DIR=1 \
   POETRY_VIRTUALENVS_IN_PROJECT=true \
   PYTHONWARNINGS="ignore:Unverified HTTPS request" \
   POETRY_HOME=/usr/local

COPY ./python-install.sh /usr/local/share/python-install.sh
RUN /bin/bash /usr/local/share/python-install.sh