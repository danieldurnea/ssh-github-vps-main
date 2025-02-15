# sd
FROM ubuntu
ARG AUTH_TOKEN
ARG PASSWORD
ARG DEBIAN_FRONTEND=noninteractive

LABEL maintainer="Matt McNamee"

# Environment Variables
ENV HOME=/root
ENV TOOLS="/opt"
ENV ADDONS="/usr/share/addons"
ENV WORDLISTS="/usr/share/wordlists"
ENV GO111MODULE=on
ENV GOROOT=/usr/local/go
ENV GOPATH=/go
ENV PATH=${HOME}/:${GOPATH}/bin:${GOROOT}/bin:${PATH}
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


# ------------------------------
# --- Finished ---
# ------------------------------

# Start up commands
ENTRYPOINT ["bash", "/docker-to-bash.sh"]
CMD ["/bin/zsh"]
