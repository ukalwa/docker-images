FROM ubuntu:20.04

ENV LD_LIBRARY_PATH=/usr/lib/oracle/19.11/client64/lib:$LD_LIBRARY_PATH \
    ORACLE_HOME=/usr/lib/oracle/19.11/client64 \
    TZ=America/Chicago \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get install -y --no-install-recommends curl gnupg2 ca-certificates unzip alien libaio1 \
        tmux vim net-tools openssh-client postgresql-client zsh git \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | tee /etc/apt/sources.list.d/msprod.list \
    && curl https://download.oracle.com/otn_software/linux/instantclient/1911000/oracle-instantclient19.11-basic-19.11.0.0.0-1.x86_64.rpm \
    --output oracle-instantclient19.11-basic-19.11.0.0.0-1.x86_64.rpm \
    && curl https://download.oracle.com/otn_software/linux/instantclient/1911000/oracle-instantclient19.11-devel-19.11.0.0.0-1.x86_64.rpm \
    --output oracle-instantclient19.11-devel-19.11.0.0.0-1.x86_64.rpm \
    && alien -i oracle-instantclient19.11-basic-19.11.0.0.0-1.x86_64.rpm \
    && alien -i oracle-instantclient19.11-devel-19.11.0.0.0-1.x86_64.rpm \
    && mkdir -p ${ORACLE_HOME}/dbms/public \
    && cp /usr/include/oracle/19.11/client64/* $ORACLE_HOME/dbms/public \
    && apt-get update -qq \
    && ACCEPT_EULA=Y apt-get install -y --no-install-recommends mssql-tools18 unixodbc-dev msodbcsql18 \
    # Fix sql server connection issues due to SSL security levels
    && chmod +rwx /etc/ssl/openssl.cnf \
    && sed -i 's/TLSv1.2/TLSv1/g' /etc/ssl/openssl.cnf \
    && sed -i 's/SECLEVEL=2/SECLEVEL=1/g' /etc/ssl/openssl.cnf \
    # Clean up
    && apt-get remove -y alien \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* oracle-instantclient19.11-*.rpm \
    && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' | tee -a /root/.bashrc >> /root/.zshrc \
    && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions \
    && echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
