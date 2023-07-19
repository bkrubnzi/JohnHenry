# Pre post-install:
# fix visudo: update-alternatives --config editor

# This is a post-installation script for Kali Linux.
# It is tested on:
#    - ESXi 8.0.1
#    - Kali-linux-2023.2a installer
# It installs:
#    - XRDP (remote desktop host service)
#    - Websploit platform
# It requires root priveleges to run.

#!/bin/bash

if [ -z `systemctl list-unit-files --all | grep 'xrdp\.'` ]; then
    curl -sSL https://gitlab.com/kalilinux/recipes/kali-scripts/-/raw/main/xfce4.sh | bash
    systemctl enable xrdp --now
    echo "RDP Installation complete.  Please Reboot and run this script again."
    exit 0
else
    echo "XRDP installed.  Would you like to install Websploit?"
    echo -n "[Y/N]:"; read input
    if [ $input = "Y" ]; then
        curl -sSL https://websploit.org/install.sh | bash
        echo "Websploit installation complete."
        echo "Please add your unprivileged account to the docker group"
        echo "using the command \"usermod -a -G docker \$username\""
        echo "and reboot."
    fi
fi
echo "post-installation script complete."
exit 0

# Post post-install:
#   - Update websploit using
#     curl -sSL https://websploit.org/update.sh | sudo bash
#   - Attach containers one at a time:
#       - docker rm -f $(docker ps -aq) 
#       - docker run --name mayhem -itd -p 80:80 -p 22:22 santosomar/mayhem (for example)
#   - Clean up RDP error on login:
        #cat <<EOF | sudo tee /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla
        #[Allow Colord all Users]
        #Identity=unix-user:*
        #Action=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile
        #ResultAny=no
        #ResultInactive=no
        #ResultActive=yes
        #EOF
