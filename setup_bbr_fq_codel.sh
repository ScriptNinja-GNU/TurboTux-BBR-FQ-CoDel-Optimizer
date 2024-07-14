#!/bin/bash

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

echo "Checking for BBR availability..."

# Check if BBR is available
if ! sysctl net.ipv4.tcp_available_congestion_control | grep -q bbr; then
    echo "BBR not found. Attempting to enable it..."
    modprobe tcp_bbr
    echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
    
    # Check again if BBR is now available
    if ! sysctl net.ipv4.tcp_available_congestion_control | grep -q bbr; then
        echo "Failed to enable BBR. Your kernel might not support it."
        echo "To resolve this:"
        echo "1. Ensure your kernel version is 4.9 or later. Current version: $(uname -r)"
        echo "2. If your kernel is outdated, consider upgrading: 'sudo apt update && sudo apt upgrade'"
        echo "3. If using a custom kernel, make sure it's compiled with BBR support."
        echo "4. If issues persist, please report this on the project's GitHub page."
        exit 1
    fi
fi

echo "Configuring sysctl for BBR and FQ-CoDel..."

# Configure sysctl
cat >> /etc/sysctl.conf <<EOL

# BBR and FQ-CoDel settings
net.core.default_qdisc = fq_codel
net.ipv4.tcp_congestion_control = bbr
EOL

# Apply sysctl changes
sysctl -p

# Ensure changes persist after reboot
if [[ ! -f /etc/rc.local ]]; then
    echo "#!/bin/sh -e" > /etc/rc.local
    echo "exit 0" >> /etc/rc.local
    chmod +x /etc/rc.local
fi

sed -i '/exit 0/i\sysctl -w net.ipv4.tcp_congestion_control=bbr' /etc/rc.local
sed -i '/exit 0/i\sysctl -w net.core.default_qdisc=fq_codel' /etc/rc.local

echo "Verifying settings..."

# Verify settings
sysctl net.ipv4.tcp_congestion_control
sysctl net.core.default_qdisc

echo "Setup complete. Please reboot your system for changes to take full effect."
