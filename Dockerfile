FROM athenaos/base:latest

ARG DEBIAN_FRONTEND=noninteractive
RUN
ARG PASSWORD=rootuser$$#
ARG DNS_NAMESERVER=1.1.1.1

# Install packages and set locale

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
    
CMD ["/bin/bash", "/docker.sh"]    


