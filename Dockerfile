# Use Ubuntu noble (24.04) as the base image
FROM ubuntu
# Set the environment variable to disable interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set the PRoot version
ENV PROOT_VERSION=5.4.0

# Install necessary packages

# Install packages and set locale
RUN apt-get update \
    && apt-get install -y locales nano unzip ssh sudo python3 curl wget \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

# Configure SSH tunnel using ngrok
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.utf8

# Configure locale
RUN update-locale lang=en_US.UTF-8 && \
    dpkg-reconfigure --frontend noninteractive locales

# Install PRoot
RUN ARCH=$(uname -m) && \
    mkdir -p /usr/local/bin && \
    proot_url="https://github.com/ysdragon/proot-static/releases/download/v${PROOT_VERSION}/proot-${ARCH}-static" && \
    curl -Ls "$proot_url" -o /usr/local/bin/proot && \
    chmod 755 /usr/local/bin/proot


# Switch to the new user

# Set the working directory
WORKDIR /home/container


# Make the copied scripts executable

# Set the default comman

# Define arguments and environment variables

EXPOSE 80 8888 8080 443 5130-5135 3306 7860

# Expose port
