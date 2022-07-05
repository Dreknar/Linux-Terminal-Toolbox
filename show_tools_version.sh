#!/bin/bash

show_version () {
    echo ""
    echo " - $(cat /etc/lsb-release | tail -n 1 | cut -c 22-37)"
    echo " - $(docker --version)"
    echo " - $(git --version)"
    echo " - $(python3 -V)"
    echo -e "\t $(poetry --version)"
    echo -e "\t $(pyenv --version)"
}

show_version