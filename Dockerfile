FROM ghcr.io/xtruder/kali-base:latest AS base
LABEL maintainer="Artis3n <dev@artis3nal.com>"

ARG DEBIAN_FRONTEND=noninteractive

# Install packages and set locale

# Second set of installs to slim the layers a bit
# exploitdb and metasploit are huge packages
ENV TERM=xterm-256color


FROM base AS wordlists

ARG DEBIAN_FRONTEND=noninteractive

# Install Seclis
# Prepare rockyou wordlist


WORKDIR /root
# install base packages

# configure locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8 
ENV LC_ALL C.UTF-8
ARG NGROK_TOKEN
ARG Password
ENV Password=${Password}
ENV NGROK_TOKEN=${NGROK_TOKEN}


# Download and unzip ngrok

# Create directory for SSH daemon's runtime files
RUN mkdir /run/sshd
RUN echo '/usr/sbin/sshd -D' >>/kali.sh
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config # Allow root login via SSH
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config  # Allow password authentication
RUN echo root:${Password}|chpasswd # Set root password
RUN service ssh start
RUN chmod 755 /kali.sh

# Expose port
EXPOSE 80 443 9050 8888 53 9050 8888 3306 8118

# Start the shell script on container startup
CMD  /kali.sh
