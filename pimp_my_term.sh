#!/bin/bash

echo '========== Update and upgrade system =========='
sudo apt update && sudo apt upgrade -y

echo '========== Install ZSH and oh my ZSH. =========='
sudo apt install zsh -y
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
sudo apt install zsh-autosuggestions zsh-syntax-highlighting -y

echo '========== Prepare files =========='
./data/pimp_my_term/install.sh

echo '========== Install extra tools =========='
cd /tmp
wget https://github.com/Peltoche/lsd/releases/download/0.22.0/lsd_0.22.0_amd64.deb
sudo dpkg -i lsd_0.22.0_amd64.deb

wget https://github.com/sharkdp/bat/releases/download/v0.21.0/bat_0.21.0_amd64.deb
sudo dpkg -i bat_0.21.0_amd64.deb

wget https://github.com/aristocratos/btop/releases/download/v1.2.8/btop-x86_64-linux-musl.tbz
mkdir btop
sudo tar -xvf btop-x86_64-linux-musl.tbz -C btop
sudo ./btop/install.sh

sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /usr/share/zsh-theme-powerlevel10k