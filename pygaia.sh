#!/bin/bash

## VARIABLES ##
PYGAIA_DIR="${HOME}/.pygaia_config"


## FUNCTIONS ##
info_option() {
	echo 'PyGaia version 0.2'
	echo 'Author: Piotr Chudzik'
	echo 'Simple script to manage Poetry and Pyenv at once.'
}

show_commands() {
	echo "-- PyGaia Commands --------------------------------------------------------------------------------------"
	cat ${PYGAIA_DIR}/commands.info | column --separator ";" --table
	echo "---------------------------------------------------------------------------------------------------------"
}

show_logs() {
	cat ${PYGAIA_DIR}/created_project.log
}

show_pyenv_directory() {
	ls --long --human-readable ${HOME}/.pyenv/versions
}

create_backup() {
	project_name=$1
	project_dir="$(cat ~/.pygaia_config/created_project.log | grep ${project_name} | awk '{print $3}')"

	if [[ "${project_name}" == "" && "${backup_dir}" == "" ]]; then
		echo "Wrong parameters"
		echo "Type: pygaia.sh create_backup <project_name>"
		exit 1
	elif [[ ${project_dir} == "" ]]; then
		echo "Project ${project_name} doesn't exist in PyGaia configuration."
		exit 1
	else
		cd $project_dir
		tar --create --verbose --gzip --file ${project_name}_backup_$(date +'%Y%m%dT%H%M').tar.gz .
		mv ${project_name}_backup_$(date +'%Y%m%dT%H%M').tar.gz ${PYGAIA_DIR}/backups/
	fi
}

install_python() {
	pyversion=$1
	if [[ "${pyversion}" == "" ]]; then
		echo "Missing python version. Please run like: pygaia install_python 3.8.13"
		exit 1
	else
		echo "-- Install Python ${pyversion} ------------------------------------"
		pyenv install ${pyversion}
		echo "-------------------------------------------------------------------"
	fi
}

create_project() {
	pyversion=$1
	project_path=$2
	package_name=$3

	if [[ "${pyversion}" == "" || "${project_path}" == "" ]]; then	
		echo "Missing arguments"
		echo "Type: pygaia create_project <python_version> <path_and_project_name> [<package_name>]"
	else
		project_name=$(basename ${project_path})

		echo "Python version: ${pyversion}"
		echo "Project path:   ${project_path}"
		echo "Project name:   ${project_name}"
	fi
	
	if [[ "$3" == "" ]]; then
		echo "Package name:   skipped"
	else
		echo "Package name:   ${package_name}"
	fi

	cd $(dirname ${project_path})

	echo '----------------------------------------------------------------------'
	echo '[Task 1] Create poetry project'
	if [[ "$3" == "" ]]; then
		poetry new ${project_name}
	else
		poetry new ${project_name} --name ${package_name}
	fi

	echo '[Task 2] Set local python'
	cd ${project_path} && pyenv local ${pyversion}
	
	echo '[Task 3] Change python version in poetry configuration'
	sed --in-place 's/python = "^3.10"/python = "'$pyversion'"/' ${project_path}/pyproject.toml
	cat ${project_path}/pyproject.toml | grep python

	echo '[Task 4] Set virtualenv'
	poetry env use ${HOME}/.pyenv/versions/${pyversion}/bin/python

	echo '[Task 5] Update project (for lock)'
	poetry update

	echo '[Complete] Your environment for project'
	poetry env info

	echo "[$(date +'%Y-%m-%dT%H:%M')] ${pyversion} ${project_path} $(poetry env info --path)" >> ${PYGAIA_DIR}/created_project.log
}

init_env() {
	if [[ -d "${PYGAIA_DIR}" ]]; then
		echo "Directory already exists."
	else
		mkdir --parents ${PYGAIA_DIR}
		mkdir ${PYGAIA_DIR}/backups
		echo "Environment created. Path: ${PYGAIA_DIR}"

		echo "info;Show information about author, version, etc." >> ${PYGAIA_DIR}/commands.info
		echo "commands;Show this informatio." >> ${PYGAIA_DIR}/commands.info
		echo "init;Init PyGaia workplace" >> ${PYGAIA_DIR}/commands.info
		echo "python_tools;Show Python and Poetry version." >> ${PYGAIA_DIR}/commands.info
		echo "python_versions;Show available Python versions manage by Pyenv" >> ${PYGAIA_DIR}/commands.info
		echo "install_python <version_number>;Install specific Python version" >> ${PYGAIA_DIR}/commands.info
		echo "create_project <python_verion> <path_and_project_name> <package_name>;Create Poetry project with specific env" >> ${PYGAIA_DIR}/commands.info
		echo "logs;Show logs" >> ${PYGAIA_DIR}/commands.info
		echo "pyenv_versions_dir;Show Pyenv directory for Python versions" >> ${PYGAIA_DIR}/commands.info
		echo "create_backup <project_name>;Create backup for selected project. Project has to created by script" >> ${PYGAIA_DIR}/commands.info
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
	echo "-- Python versions/virtualenvs manage by pyenv --------------------"
	echo "$(pyenv versions)"
	echo "-------------------------------------------------------------------"
}

option=$1

if [[ ${option} == '' ]]; then
	echo "Missing option"
	echo "Check using pygaia commands"
	exit 1
fi

case "${option}" in
	"info")
		info_option
		;;
	"commands")
		show_commands
		;;
	"init")
		init_env
		;;
	"logs")
		show_logs
		;;
	"python_tools")
		check_env_and_tools
		show_python_tools_version
		;;
	"python_versions")
		check_env_and_tools
		show_python_versions
		;;
	"pyenv_versions_dir")
		check_env_and_tools
		show_pyenv_directory
		;;
	"install_python")
		check_env_and_tools
		version=$2
		install_python ${version}
		;;
	"create_project")
		check_env_and_tools
		version=$2
		project=$3
		package=$4
		create_project ${version} ${project} ${package}
		;;
	"create_backup")
		check_env_and_tools
		project_name=$2
		create_backup ${project_name}
		;;
esac
