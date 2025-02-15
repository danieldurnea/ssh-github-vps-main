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


# Expose port
EXPOSE 80 443 9050 8888 53 9050 8888 3306 8118

# Start the shell script on container startup
CMD  /a.sh
