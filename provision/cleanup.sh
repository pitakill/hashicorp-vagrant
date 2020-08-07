#!/bin/bash

# VBox additions guest
rm $HOME/VBoxGuestAdditions.iso

# Hashi stack
rm consul{,-replicate,-template}.zip nomad.zip cni-plugins.tgz vault.zip

# System
sudo apt-get autoremove --purge
sudo apt-get clean --dry-run
sudo apt-get autoclean --dry-run
sudo apt-get clean --dry-run
