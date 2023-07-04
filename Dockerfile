FROM kalilinux/kali-rolling:latest AS base
LABEL maintainer="Artis3n <dev@artis3nal.com>"
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils \
    && apt-get install -y --no-install-recommends  amass awscli curl dnsutils \
    dotdotpwn file finger ffuf gobuster git hydra impacket-scripts john less locate \
    lsof man-db netcat-traditional nikto nmap proxychains4 python3 python3-pip python3-setuptools \
    python3-wheel smbclient smbmap socat ssh-client sslscan sqlmap telnet tmux unzip whatweb vim zip \
    # Slim down layer size
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    # Remove apt-get cache from the layer to reduce container size
    && rm -rf /var/lib/apt/lists/*

# Second set of installs to slim the layers a bit
# exploitdb and metasploit are huge packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    exploitdb metasploit-framework \
    # Slim down layer size
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists*
ARG AUTH_TOKEN
ARG PASSWORD=rootuser$$#

# Install packages and set locale
RUN apt-get update \
    && apt-get install -y apt-utils locales nano ssh sudo python3 curl wget \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

# Configure SSH tunnel using ngrok
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.utf8

RUN wget -O ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip \
    && unzip ngrok.zip \
    && rm /ngrok.zip \
    && mkdir /run/sshd \
    && echo "/ngrok tcp --authtoken ${AUTH_TOKEN} 22 &" >>/docker.sh \
    && echo "sleep 5" >> /docker.sh \
    && echo "curl -s http://localhost:4040/api/tunnels | python3 -c \"import sys, json; print(\\\"SSH Info:\\\n\\\",\\\"ssh\\\",\\\"root@\\\"+json.load(sys.stdin)['tunnels'][0]['public_url'][6:].replace(':', ' -p '),\\\"\\\nROOT Password:${PASSWORD}\\\")\" || echo \"\nError：AUTH_TOKEN，Reset ngrok token & try\n\"" >> /docker.sh \
    && echo '/usr/sbin/sshd -D' >>/docker.sh \
    && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config \
    && echo root:${PASSWORD}|chpasswd \
    && chmod 755 /docker.sh
    && chmod 755 /entrypoint.sh
    
ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["/bin/bash", "/docker.sh"]

