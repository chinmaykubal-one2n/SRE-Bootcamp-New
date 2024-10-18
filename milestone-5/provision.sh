#!/bin/bash

# Update package lists
sudo apt-get update

# Install make  
install_make() {
  echo "Installing make dependency..."
  sudo apt install make -y  
}

# Install Docker 
install_docker() {
  echo "Installing docker dockerdependencies..."
  sudo apt-get install ca-certificates curl -y
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo \
 "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
 $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
  sudo service docker start
  sudo usermod -aG docker ${USER}
  sudo systemctl start docker
  sudo systemctl enable docker

}

# Main execution
main() {
  install_make
  install_docker

}

main

cd /vagrant/application
make docker-compose-up-students-api 