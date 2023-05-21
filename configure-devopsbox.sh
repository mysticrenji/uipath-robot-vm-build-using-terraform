#!/bin/sh
sudo apt-get update
sudo apt-get install -y python3-dev python3-pip
pip3 install setuptools-rust pywinrm
pip3 install --upgrade pip
sudo apt install -y ansible
ansible-galaxy collection install ansible.windows
