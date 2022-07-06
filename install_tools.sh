#!/bin/bash

option=$1

if [[ $1 == '' ]]; then
    echo 'Missing option'
    echo 'Available: pyenv, poetry, docker'
    exit 1
fi

if [[ $1 == 'docker' ]]; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm -rf get-docker.sh
    echo 'Please remember execute: sudo usermod -aG docker <your_username> for rootless access.'
fi

if [[ $1 == 'poetry' ]]; then
    curl -sSL https://install.python-poetry.org | python3 -
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
fi

if [[ $1 == 'micro' ]]; then
	cd /usr/bin
	sudo curl https://getmic.ro | sudo bash

if [[ $1 == 'pyenv' ]]; then
    curl https://pyenv.run | bash

    echo -e '\nexport PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc

    echo -e '\nexport PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc
fi
