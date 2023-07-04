#!/bin/bash

readonly SPLASH="
▄▄▄▄·       ▐▄• ▄ ▄▄▄ .·▄▄▄▄      ▄ •▄  ▄▄▄· ▄▄▌  ▪
▐█ ▀█▪▪      █▌█▌▪▀▄.▀·██▪ ██     █▌▄▌▪▐█ ▀█ ██•  ██
▐█▀▀█▄ ▄█▀▄  ·██· ▐▀▀▪▄▐█· ▐█▌    ▐▀▀▄·▄█▀▀█ ██▪  ▐█·
██▄▪▐█▐█▌.▐▌▪▐█·█▌▐█▄▄▌██. ██     ▐█.█▌▐█ ▪▐▌▐█▌▐▌▐█▌
·▀▀▀▀  ▀█▄▀▪•▀▀ ▀▀ ▀▀▀ ▀▀▀▀▀•     ·▀  ▀ ▀  ▀ .▀▀▀ ▀▀▀
"

function set_dns_nameserver() {
  DNS_NAMESERVER="${DNS_NAMESERVER:-1.1.1.1}"
  echo "nameserver $DNS_NAMESERVER" >> /etc/resolv.conf
}

function start_postgresql() {
  service postgresql start
  msfdb init > /dev/null 2>&1 &
}




