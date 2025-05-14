FROM ubuntu:22.04

RUN apt update && apt install -y \
    docker.io \
    curl \
    unzip \
    wget \
    tar \
    python3 \
    python3-pip \
    libx11-xcb1 \
    libgbm1 \
    libasound2 \
    libnss3 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    gnupg \
    openjdk-17-jdk \
    lsb-release \
    jq \
  && apt clean && rm -rf /var/lib/apt/lists/*

 # Install Azure CLI
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/azure-cli-archive-keyring.gpg \
&& echo "deb [arch=amd64 signed-by=/usr/share/keyrings/azure-cli-archive-keyring.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/azure-cli.list \
&& apt update && apt install -y azure-cli \
&& rm -rf /var/lib/apt/lists/*

RUN pip3 install flask azure-identity azure-keyvault-secrets

# הגדרת JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

  # Configure Docker daemon
RUN mkdir -p /etc/docker && echo '{"storage-driver": "overlay2"}' > /etc/docker/daemon.json
VOLUME /var/lib/docker

# Install sonar-scanner
RUN curl -sSL https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip -o sonar-scanner.zip \
  && unzip sonar-scanner.zip -d /opt/ \
  && ln -s /opt/sonar-scanner-5.0.1.3006-linux/bin/sonar-scanner /usr/local/bin/sonar-scanner \
  && rm sonar-scanner.zip

# Vault CLI
RUN wget -q https://releases.hashicorp.com/vault/1.13.0/vault_1.13.0_linux_amd64.zip -O vault.zip && \
    unzip vault.zip && mv vault /usr/local/bin/ && chmod +x /usr/local/bin/vault && rm vault.zip
    
RUN useradd -ms /bin/bash mikaadmin && usermod -aG docker mikaadmin

WORKDIR /azagent

# install Azure Pipelines Agent
ENV AZP_AGENTPACKAGE_URL=https://vstsagentpackage.azureedge.net/agent/4.254.0/vsts-agent-linux-x64-4.254.0.tar.gz
WORKDIR /azagent
RUN curl -LsS $AZP_AGENTPACKAGE_URL | tar -xz

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
