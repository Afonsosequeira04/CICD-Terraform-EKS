#!/bin/bash

set -eux  # Exit on error, print commands, treat unset variables as error

sudo apt-get update
sudo apt-get install -y openjdk-17-jdk-headless wget unzip

echo "Adding Jenkins key and repository..."
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list

sudo apt-get update
sudo apt-get install -y jenkins

sudo systemctl enable jenkins
sudo systemctl start jenkins

echo "Installing Terraform..."
wget https://releases.hashicorp.com/terraform/1.6.5/terraform_1.6.5_linux_amd64.zip

sudo unzip terraform_1.6.5_linux_amd64.zip -d /usr/local/bin/
sudo chmod +x /usr/local/bin/terraform

echo "Jenkins and Terraform installation complete."
