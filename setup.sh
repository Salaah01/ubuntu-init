#!/usr/bin/env bash

# Everything should be run as root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

apt update
apt upgrade -y

# Build packages
apt install build-essential software-properties-common -y

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
apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm awscliv2.zip

# Node JS
# https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-20-04#option-2-installing-node-js-with-apt-using-a-nodesource-ppa
curl -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh
bash nodesource_setup.sh
apt install nodejs
rm nodesource_setup.sh

# To allow certain Python packages to be installed
apt install libpq-dev -y

# Find out Python version and install venv for the version
PYTHON_VERSION=$(python3 -c 'import sys; version=sys.version_info[:3]; print("{0}.{1}".format(*version))')
apt install python${PYTHON_VERSION}-venv python3-venv -y