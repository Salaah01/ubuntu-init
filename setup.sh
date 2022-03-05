#!/usr/bin/env bash

# Everything should be run as root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

apt update
apt upgrade -y

# PostgreSQL
# https://www.postgresql.org/download/linux/ubuntu/
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt update
apt -y install postgresql

# Docker
# https://docs.docker.com/engine/install/ubuntu/
# The following script will download the latest edge version. If Docker does
# not work after installation properly, it is a good idea to uninstall and
# install the stable version.
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
rm get-docker.sh
usermod -aG docker root

# Docker Compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# AWS CLI
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
apt -y install awscli
