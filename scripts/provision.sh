#!/usr/bin/env bash
set -e

# Install packages
dnf install -y epel-release
dnf install -y bash-completion python36 python3-libvirt python3-requests python3-paramiko python3-firewall python3-libguestfs

# Update pip
pip3 install -U pip

# Install pyinstaller
if [[ ! -f /usr/local/bin/pyinstaller ]]; then
  pip3 install pyinstaller
fi

# Install fastapi
pip3 install fastapi

# Cleanup directory
cd /vagrant/src
if [[ -d dist || -d build ]]; then
  rm -rf dist build
fi

echo "Creating hostvirtmgr binary..."
/usr/local/bin/pyinstaller --onefile main.py

# Copy INI files
cp ../conf/ini/hostvirtmgr.ini dist/

# Check release folder
if [[ ! -d ../release ]]; then
  mkdir ../release
fi

tar -czf ../release/hostvirtmgr-centos8-amd64.tar.gz --transform s/dist/hostvirtmgr/ dist

echo ""
echo "Release is ready!"
