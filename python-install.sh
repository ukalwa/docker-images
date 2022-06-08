#!/usr/bin/env bash
OS=$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d \")

if [ "$OS" = "Alpine Linux" ]; then
    apk update
    apk add --update --no-cache --virtual .tmp-build-deps \
        gcc libc-dev linux-headers postgresql-dev
    apk add --no-cache libffi-dev  python3 python3-dev py-cryptography \
        build-base linux-headers libc6-compat gcc musl-dev postgresql-dev
    
    python3 -m ensurepip
    ln -sf python3 /usr/bin/python
    ln -sf pip3 /usr/bin/pip
else
    echo '
deb https://ppa.launchpadcontent.net/deadsnakes/ppa/ubuntu focal main 
deb-src https://ppa.launchpadcontent.net/deadsnakes/ppa/ubuntu focal main' >> /etc/apt/sources.list
    echo '-----BEGIN PGP PUBLIC KEY BLOCK-----
Comment: Hostname: 
Version: Hockeypuck ~unreleased

xsFNBFl8fYEBEADQmGZ6pDrwY9iH9DVlwNwTOvOZ7q7lHXPl/TLfMs1tckMc/D9a
hsdBN9VWtMmo+RySvhkIe8X15r65TFs2HE8ft6j2e/4K472pObM1hB+ajiU/wYX2
Syq7DBlNm6YMP5/SyQzRxqis4Ja1uUjW4Q5/Csdf5In8uMzXj5D1P7qOiP2aNa0E
r3w6PXWRTuTihWZOsHv8npyVYDBRR6gEZbd3r86snI/7o8Bfmad3KjbxL7aOdNMw
AqQFaNKl7Y+UJpv1CNFIf+twcOoC0se1SrsVJlAH9HNHM7XGQsPUwpNvQlcmvr+t
1vVS2m72lk3gyShDuJpi1TifGw+DoTqu54U0k+0sZm4pnQVeiizNkefU2UqOoGlt
4oiG9nIhSX04xRlGes3Ya0OjNI5b1xbcYoR+r0c3odI+UCw3VSZtKDX/xlH1o/82
b8ouXeE7LA1i4DvGNj4VSvoxv4ggIznxMf+PkWXWKwRGsbAAXF52rr4FUaeaKoIU
DkJqHXAxrB3PQslZ+ZgBEukkQZF76NkqRqP1E7FXzZZMo2eEL7vtnhSzUlanOf42
ECBoWHVoZQaRFMNbGpqlg9aWedHGyetMStS3nH1sqanr+i4I8VR/UH+ilarPTW3T
E0apWlsH8+N3IKbRx2wgrRZNoQEuyVtvyewDFYShJB3Zxt7VCy67vKAl1QARAQAB
zRxMYXVuY2hwYWQgUFBBIGZvciBkZWFkc25ha2VzwsF4BBMBAgAiBQJZfH2BAhsD
BgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRC6aTI2anVXdvwhD/4oI3yckeKn
9aJNNTJsyw4ydMkIAOdG+jbZsYv/rN73UVQF1RA8HC71SDmbd0Nu80koBOX+USuL
vvhoMIsARlD5dLx5f/zaQcYWJm/BtsMF/eZ4s1xsenwW6PpXd8FpaTn1qtg/8+O9
99R4uSetAhhyf1vSRb/8U0sgSQd38mpZZFq352UuVisXnmCThj621loQubYJ3lwU
LSLs8wmgo4XIYH7UgdavV9dfplPh0M19RHQL3wTyQP2KRNRq1rG7/n1XzUwDyqY6
eMVhdVhvnxAGztvdFCySVzBRr/rCw6quhcYQwBqdqaXhz63np+4mlUNfd8Eu+Vas
b/tbteF/pDu0yeFMpK4X09Cwn2kYYCpq4XujijW+iRWb4MO3G8LLi8oBAHP/k0CM
/QvSRbbG8JDQkQDH37Efm8iE/EttJTixjKAIfyugmvEHfcrnxaMoBioa6h6McQrM
vI8bJirxorJzOVF4kY7xXvMYwjzaDC8G0fTA8SzQRaShksR3USXZjz8vS6tZ+YNa
mRHPoZ3Ua0bz4t2aCcu/fknVGsXcNBazNIK9WF2665Ut/b7lDbojXsUZ3PpuqOoe
GQL9LRj7nmCI6ugoKkNp8ZXcGJ8BGw37Wep2ztyzDohXp6f/4mGgy2KYV9R4S8D5
yBDUU6BS7Su5nhQMStfdfr4FffLmnvFC9w==
=s7P2
-----END PGP PUBLIC KEY BLOCK-----' >> /tmp/hockeypuck.gpg
    apt-key add /tmp/hockeypuck.gpg
    apt-get update
    apt-get install -y python3.10 python3.10-distutils python3.10-venv
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10
    ln -sf python3.10 /usr/bin/python
    ln -sf python3.10 /usr/bin/python3
fi

python -m pip install --upgrade pip
#install virutal environments tools
curl -skSL https://install.python-poetry.org | python3 -


# Clean up
if [ "$OS" = "Alpine Linux" ]; then
    apk del .tmp-build-deps
    rm -rf /var/cache/apk/*
else
    apt autoremove -y
    rm -rf /var/lib/apt/lists/*
fi