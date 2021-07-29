#!/bin/sh
# Install script for sys-oled

INSTALL_PATH="/usr/local/"
SYSTEMD_PATH="/etc/systemd/"
DEPS="python3-dev python3-pip python3-setuptools python3-wheel python3-psutil libfreetype6-dev libjpeg-dev build-essential"

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root!"
    exit 1
fi

echo "Installing Dependencies"
apt-get update
apt-get install -y $DEPS

# luma.oled depends on this thing, but released non-alpha version does not build under gcc10
echo "Installing GPIO library dependency in pip..."
pip3 install RPi.GPIO==0.7.1a4

echo "Installing luma.oled library"
pip3 install --upgrade luma.oled

echo "Installing sys-oled files"
cp -fv etc/sys-oled.conf  /etc
cp -frv bin "$INSTALL_PATH"
cp -frv share "$INSTALL_PATH"
cp -frv system "$SYSTEMD_PATH"

echo "Enabling sys-oled at startup"
systemctl daemon-reload
systemctl enable sys-oled.service

echo "Starting service..."
systemctl start sys-oled.service
