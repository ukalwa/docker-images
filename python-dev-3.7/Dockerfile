FROM ukalwa/debian-base

ENV PYTHONUNBUFFERED 1
ENV NONROOT_USER vscode

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y python3-pip \
    && python3 -m pip install pipenv \
    pylint \
    flake8 \
    autopep8 \
    black \
    yapf \
    mypy \
    pydocstyle \
    pycodestyle \
    bandit \
    virtualenv \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
# Alias default python to python3
RUN echo "alias python=python3\nalias pip=pip3\n" \
    | tee -a /root/.bashrc /home/${NONROOT_USER}/.bashrc /home/${NONROOT_USER}/.zshrc >> /root/.zshrc
ENV DEBIAN_FRONTEND=dialog