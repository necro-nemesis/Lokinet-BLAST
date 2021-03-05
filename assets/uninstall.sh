#!/bin/bash

sudo apt remove lokinet-gui -y && sudo apt remove lokinet -y
sudo systemctl restart dhcpcd
sudo rm /usr/share/applications/Lokinet.desktop || install_error "Unable to remove startup entry"
sudo rm /usr/pixmaps/lokiremove.png || install_error "Unable to remove startup icon"
sudo rm -r /etc/lokinet || install_error "Unable to remove lokinet removal files"
