#!/bin/bash
# Build, upload, and install all packages on a salt-master.
#  ~~~> Remote side, see install-on-master.sh


# Configuration.
REMOTE_TMP=$1
SPM_DIR=${SPM_DIR:="/data/www/spm/repo"}
SUDO=${SUDO="sudo"}


# Clean repo.
echo "~~~> Cleaning repo directory"
${SUDO} rm "${SPM_DIR}"/*
echo
echo


# Copy and refresh repo.
echo "~~~> Copying new packages and refreshing repo"
${SUDO} cp -rv "${REMOTE_TMP}"/* "${SPM_DIR}"
${SUDO} spm create_repo "${SPM_DIR}"
${SUDO} spm update_repo
echo
echo


# Force install all desired packages.
echo "~~~> Force installing packages to update"
${SUDO} spm install --assume-yes --force --verbose sp-master-conf
${SUDO} spm install --assume-yes --force --verbose sp-spm-repo-conf

${SUDO} spm install --assume-yes --force --verbose patched-redis
${SUDO} spm install --assume-yes --force --verbose patched-users

${SUDO} spm install --assume-yes --force --verbose sp-apt
${SUDO} spm install --assume-yes --force --verbose sp-essential
${SUDO} spm install --assume-yes --force --verbose sp-glue
${SUDO} spm install --assume-yes --force --verbose sp-nginx
${SUDO} spm install --assume-yes --force --verbose sp-redis
${SUDO} spm install --assume-yes --force --verbose sp-spm-repo
