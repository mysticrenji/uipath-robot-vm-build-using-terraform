#!/bin/sh
sudo apt-get update
sudo apt-get install -y python3-dev python3-pip
pip3 install setuptools-rust pywinrm ansible
pip3 install --upgrade pip
ansible-galaxy collection install community.windows

sudo apt-get update && sudo apt-get install -y gnupg software-properties-common gpg
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y terraform
