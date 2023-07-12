# This is a post-installation script for Kali Linux.
# It is tested on:
#    - ESXi 8.0.1
#    - Kali-linux-2023.2a installer
# It installs:
#    - XRDP (remote desktop host service)
#    - Websploit platform
# It requires root priveleges to run.

#!/bin/bash

xrdp_exists() {
    if [ $(systemctl list-unit-files --all | grep 'xrdp\.') ]; then
        return true
    else
        return false
    fi
}

if [ xrdp_exists == false ]; then
    curl -sSL https://gitlab.com/kalilinux/recipes/kali-scripts/-/raw/main/xfce4.sh | bash
    systemctl enable xrdp --now
    echo "RDP Installation complete.  Please Reboot and run this script again."
else
    echo "XRDP installed.  Would you like to install Websploit?"
    echo -n "[Y/N]:"; read input
    if [ $input = "Y" ]; then
        curl -sSL https://websploit.org/install.sh | bash
        echo "Websploit installation complete."
        echo "Please add your unprivileged account to the docker group"
        echo "using the command \"usermod -a -G docker \$username\"
        echo "and reboot."
    fi
fi
echo "post-installation script complete."
exit 0
