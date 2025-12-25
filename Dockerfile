FROM ubuntu
ARG NGROK_AUTH_TOKEN
ARG SSH_PASS
ENV DEBIAN_FRONTEND=noninteractive

# Create working dirs
WORKDIR /root
RUN mkdir $WORDLISTS && mkdir $ADDONS

# ------------------------------
# --- Common Dependencies ---
# ------------------------------

# Install Essentials
# Install packages and set locale
RUN apt-get update \
    && apt-get install -y locales nano unzip ssh sudo python3 curl wget \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*
    
RUN apt-get update -yq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq \
    openssh-server \
    openssh-client \
    curl \
    sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Prepare SSH configuration
RUN mkdir -p /run/sshd && \
    # Remove any existing PasswordAuthentication lines
    sed -i '/PasswordAuthentication/d' /etc/ssh/sshd_config && \
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config

# Create user with password and give sudo access
RUN useradd -m -s /bin/bash $USER && \
    echo "$USER:$PASSWORD" | chpasswd && \
    usermod -aG sudo $USER && \
    chown -R $USER:$USER /home/$USER && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Copy autoconnect/start script (if you have one)
COPY start.sh /start.sh
RUN chmod +x /start.sh && chown $USER:$USER /start.sh

# Expose SSH port
EXPOSE 22

# Start SSH daemon
CMD ["/start.sh"]
