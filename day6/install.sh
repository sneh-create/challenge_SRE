#!/bin/bash

sudo apt-get update -y
sudo apt-get install docker.io -y
sudo usermod -aG docker ubuntu && newgrp docker
echo 'Applying security hardening...'
sudo apt-get install -y aws-cli
sudo apt-get install -y amazon-linux-extras
sudo amazon-linux-extras enable epel
sudo apt-get install -y fail2ban
