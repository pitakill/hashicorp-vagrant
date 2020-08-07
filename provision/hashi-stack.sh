#!/bin/bash

export ENVOY_VERSION=1.13.1
export CONSUL_VERSION=1.7.5
export CONSUL_TEMPLATE_VERSION=0.25.0
export CONSUL_REPLICATE_VERSION=0.4.0
export CNI_PLUGINS=0.8.6
export NOMAD_VERSION=0.12.1
export VAULT_VERSION=1.4.3

# Install base
sudo apt-get update
sudo apt-get install -y \
  software-properties-common \
  unzip \
  curl \
  gnupg \
  neovim

# Install Keys
curl -sL -s https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    apt-transport-https \
    ca-certificates \
    gnupg-agent \
    software-properties-common \
    jq \
    dnsmasq

curl -L https://getenvoy.io/cli | sudo bash -s -- -b /usr/local/bin
getenvoy run standard:"${ENVOY_VERSION}" -- --version
sudo mv $HOME/.getenvoy/builds/standard/"${ENVOY_VERSION}"/linux_glibc/bin/envoy /usr/bin/envoy

cat >> ~/.bashrc <<"END"
# Coloring of hostname in prompt to keep track of what's what in demos, blue provides a little emphasis but not too much like red
NORMAL="\[\e[0m\]"
BOLD="\[\e[1m\]"
DARKGRAY="\[\e[90m\]"
BLUE="\[\e[34m\]"
PS1="$DARKGRAY\u@$BOLD$BLUE\h$DARKGRAY:\w\$ $NORMAL"
END

# Download hashi stack
curl -L https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip -o consul.zip
curl -L https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -o consul-template.zip
curl -L https://releases.hashicorp.com/consul-replicate/${CONSUL_REPLICATE_VERSION}/consul-replicate_${CONSUL_REPLICATE_VERSION}_linux_amd64.zip -o consul-replicate.zip
curl -L https://github.com/containernetworking/plugins/releases/download/v${CNI_PLUGINS}/cni-plugins-linux-amd64-v${CNI_PLUGINS}.tgz -o cni-plugins.tgz 
curl -L https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip -o nomad.zip
curl -L https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -o vault.zip

# Install consul
sudo unzip consul.zip
sudo chmod +x consul
sudo mv consul /usr/bin/consul
# Install consul-template
sudo unzip consul-template.zip
sudo chmod +x consul-template
sudo mv consul-template /usr/bin/consul-template
# Install consul-replicate
sudo unzip consul-replicate.zip
sudo chmod +x consul-replicate
sudo mv consul-replicate /usr/bin/consul-replicate
# Install momad
sudo unzip nomad.zip
sudo chmod +x nomad
sudo mv nomad /usr/bin/nomad
# Install CNI Plugin
sudo mkdir -p /opt/cni/bin
sudo tar -C /opt/cni/bin -xzf cni-plugins.tgz
# Install vault
sudo unzip vault.zip
sudo chmod +x vault
sudo mv vault /usr/bin/vault

# Add user to docker
sudo gpasswd -a $USER docker
