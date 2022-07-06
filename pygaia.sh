#!/bin/bash

## VARIABLES ##
PYGAIA_DIR="${HOME}/.pygaia_config"


## FUNCTIONS ##
info_option() {
	echo 'PyGaia version 0.2'
	echo 'Author: Piotr Chudzik'
	echo 'Simple script to manage Poetry and Pyenv at once.'
}

init_env() {
	if [[ -d "${PYGAIA_DIR}" ]]; then
		echo "Directory already exists."
	else
		mkdir -p ${PYGAIA_DIR}
		echo "Environment created. Path: ${PYGAIA_DIR}"
	fi
}

check_env_and_tools() {
	if [[ ! -d "${PYGAIA_DIR}" ]]; then
		echo "You don't have environment."
		echo "Please create using: pygaia.sh init"
		exit 1
	fi

	if [[ "$(which poetry)" == "" ]]; then
		echo "Poetry doesn't install."
		exit 1
	fi
	
	if [[ "$(which pyenv)" == "" ]]; then
		echo "Pyenv doesn't install."
		exit 1
	fi
}

show_python_tools_version() {
	echo "$(poetry --version)"
	echo "$(pyenv --version)"
}

show_python_versions() {
	echo "$(pyenv versions)"
}

option=$1

if [[ ${option} == '' ]]; then
	echo "Missing option"
	echo "Available: info, init"
	exit 1
fi

case "${option}" in
	"info")
		info_option
		;;
	"init")
		init_env
		;;
	"python_tools")
		check_env_and_tools
		show_python_tools_version
		;;
	"python_versions")
		check_env_and_tools
		echo '-- Python versions/virtualenvs manage by pyenv --------------------'
		show_python_versions
		echo '-------------------------------------------------------------------'
esac
