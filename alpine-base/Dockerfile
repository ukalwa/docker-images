FROM alpine:latest

ARG MSSQL_VERSION=18.0.1.1-1
ENV MSSQL_VERSION ${MSSQL_VERSION}

# Adding custom MS repository for mssql-tools and msodbcsql
RUN apk add --no-cache curl gnupg libaio libnsl libc6-compat ca-certificates openssh-client \
        postgresql-client openldap-clients vim bash net-tools iproute2 tmux git zsh \
    && curl -O https://download.microsoft.com/download/b/9/f/b9f3cce4-3925-46d4-9f46-da08869c6486/msodbcsql18_${MSSQL_VERSION}_amd64.apk \
    && curl -O https://download.microsoft.com/download/b/9/f/b9f3cce4-3925-46d4-9f46-da08869c6486/mssql-tools18_${MSSQL_VERSION}_amd64.apk \

    # Verifying signature
    && curl -O https://download.microsoft.com/download/b/9/f/b9f3cce4-3925-46d4-9f46-da08869c6486/msodbcsql18_${MSSQL_VERSION}_amd64.sig \
    && curl -O https://download.microsoft.com/download/b/9/f/b9f3cce4-3925-46d4-9f46-da08869c6486/mssql-tools18_${MSSQL_VERSION}_amd64.sig \
    # Importing gpg key
    && curl https://packages.microsoft.com/keys/microsoft.asc  | gpg --import - \
    && gpg --verify msodbcsql18_${MSSQL_VERSION}_amd64.sig msodbcsql18_${MSSQL_VERSION}_amd64.apk \
    && gpg --verify mssql-tools18_${MSSQL_VERSION}_amd64.sig mssql-tools18_${MSSQL_VERSION}_amd64.apk \
    # Installing packages
    && echo y | apk add --allow-untrusted msodbcsql18_${MSSQL_VERSION}_amd64.apk mssql-tools18_${MSSQL_VERSION}_amd64.apk \
    # Deleting packages
    && rm -f msodbcsql* mssql-tools* \
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' | tee -a /root/.bashrc >> /root/.zshrc \

    # Install Instantclient Basic Light Oracle and Dependencies
    && curl -o instantclient-basiclite.zip https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linuxx64.zip -SL \
    && unzip instantclient-basiclite.zip \
    && mv instantclient*/ /usr/lib/instantclient \
    && rm instantclient-basiclite.zip \
    && ln -s /usr/lib/instantclient/libclntsh.so.19.1 /usr/lib/libclntsh.so \
    && ln -s /usr/lib/instantclient/libocci.so.19.1 /usr/lib/libocci.so \
    && ln -s /usr/lib/instantclient/libociicus.so /usr/lib/libociicus.so \
    && ln -s /usr/lib/instantclient/libnnz19.so /usr/lib/libnnz19.so \
    && ln -s /usr/lib/libnsl.so.2 /usr/lib/libnsl.so.1 \
    && ln -s /lib/libc.so.6 /usr/lib/libresolv.so.2 \
    && ln -s /lib64/ld-linux-x86-64.so.2 /usr/lib/ld-linux-x86-64.so.2 \
    && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions \
    && echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc \
    #
    # Clean up
    && rm -rf /var/cache/apk/*

ENV ORACLE_BASE=/usr/lib/instantclient \
    LD_LIBRARY_PATH=/usr/lib/instantclient \
    TNS_ADMIN=/usr/lib/instantclient \
    ORACLE_HOME=/usr/lib/instantclient
