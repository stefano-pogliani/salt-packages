#!/bin/bash
# Build, upload, and install all packages on a salt-master.

# Configuration.
SALT_MASTER=${SALT_MASTER:="lon01-lef1"}
REMOTE_USER=${REMOTE_USER:="stefano"}
REMOTE_TMP=${REMOTE_TMP:="/tmp/spm-pkg-$$"}
echo "---> Script configuration"
echo "===> Master: ${SALT_MASTER}"
echo "===> Remote user: ${REMOTE_USER}"
echo "===> Remote tmp: ${REMOTE_TMP}"
echo
echo


# Build packages.
echo "---> Cleaning and building all packages"
make clean-all build-all
echo
echo


# Uploading packages to master.
echo "---> Uploading packages to master"
scp -r "out/" "${REMOTE_USER}@${SALT_MASTER}:${REMOTE_TMP}/"
echo
echo


# Running actions on remote.
echo "---> Running actions on remote"
scp "install-on-master-remote.sh" \
  "${REMOTE_USER}@${SALT_MASTER}:${REMOTE_TMP}/install-on-master-remote.sh"
ssh -tt "${REMOTE_USER}@${SALT_MASTER}" \
  "${REMOTE_TMP}/install-on-master-remote.sh" "${REMOTE_TMP}"
echo
echo


# Clean up REMOTE_TMP.
echo "---> Cleaning up ${REMOTE_TMP}"
ssh "${REMOTE_USER}@${SALT_MASTER}" rm -rv "${REMOTE_TMP}"
echo
echo
echo "---> DONE!"
