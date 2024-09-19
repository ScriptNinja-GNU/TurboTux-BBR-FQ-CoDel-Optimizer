#!/bin/bash

show_menu() {
    clear  
    echo "Welcome to the BBR with FQ-CoDel Optimizer"
    echo "1. Apply BBR and FQ-CoDel optimizations"
    echo "2. Exit"
    echo -n "Please enter your choice (1 or 2): "
}

apply_optimizations() {
    clear
    echo "Applying BBR, FQ-CoDel, and TCP optimizations..."

    if ! grep -q tcp_bbr /proc/modules && ! modprobe tcp_bbr; then
        echo "Failed to enable BBR. Your kernel might not support it."
        echo "Current kernel version: $(uname -r)"
        echo "Please ensure your kernel version is 4.9 or later and supports BBR."
        return 1
    fi

    local sysctl_config="/etc/sysctl.d/99-bbr-fq-codel-optimizations.conf"
    cat > "$sysctl_config" << EOF
# BBR and FQ-CoDel settings
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr

# Increase the maximum TCP buffer sizes
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.ipv4.tcp_rmem = 4096 87380 33554432
net.ipv4.tcp_wmem = 4096 65536 33554432

# Increase the maximum number of remembered connection requests
net.ipv4.tcp_max_syn_backlog = 8192

# Enable TCP Fast Open
net.ipv4.tcp_fastopen = 3

# Increase the maximum amount of option memory buffers
net.core.optmem_max = 65536

# Increase the tcp-time-wait buckets pool size
net.ipv4.tcp_max_tw_buckets = 1440000

# Reuse TIME-WAIT sockets for new connections when safe
net.ipv4.tcp_tw_reuse = 1

# Disable TCP slow start after idle
net.ipv4.tcp_slow_start_after_idle = 0

# Increase the UDP read buffer
net.ipv4.udp_rmem_min = 16384

# Increase the maximum number of open files
fs.file-max = 1048576

# VPN and Xray specific optimizations
net.ipv4.ip_forward = 1
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 120
net.ipv4.tcp_keepalive_probes = 5
net.ipv4.tcp_keepalive_intvl = 30

# Enable TCP window scaling
net.ipv4.tcp_window_scaling = 1

# Increase TCP max buffer size setable using setsockopt()
net.ipv4.tcp_rmem = 4096 87380 33554432
net.ipv4.tcp_wmem = 4096 65536 33554432

# Increase Linux autotuning TCP buffer limits
net.ipv4.tcp_mem = 33554432 33554432 33554432

# Increase the read-buffer space allocatable
net.ipv4.udp_rmem_min = 16384
net.ipv4.udp_wmem_min = 16384

# Increase number of incoming connections backlog
net.core.netdev_max_backlog = 16384
net.core.somaxconn = 8192

# Increase the maximum amount of memory buffers
net.core.optmem_max = 65536

# Enable low latency mode for BBR
net.ipv4.tcp_low_latency = 1

# Increase the maximum number of packets to process in a single iteration
net.core.netdev_budget = 600
net.core.netdev_budget_usecs = 8000

# Enable direct packet sending from user-space to NIC
net.core.busy_read = 50
net.core.busy_poll = 50

# Optimize network security
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.all.rp_filter = 1

# Optimize for high-speed networks
net.core.rmem_default = 1048576
net.core.wmem_default = 1048576

# Increase system-wide limit on number of open file descriptors
fs.nr_open = 2097152

# Optimize IPv4 network stack
net.ipv4.tcp_sack = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_fack = 1
net.ipv4.tcp_ecn = 0
net.ipv4.route.flush = 1
EOF

    if ! sysctl -p "$sysctl_config"; then
        echo "Failed to apply sysctl settings."
        return 1
    fi

    echo "Verifying key settings..."
    sysctl net.ipv4.tcp_congestion_control
    sysctl net.core.default_qdisc
    sysctl net.ipv4.tcp_fastopen

    echo "Setup complete. It's recommended to reboot your system for all changes to take full effect."
    echo "Press any key to continue..."
    read -n 1 -s -r
}

# Main script execution
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

while true; do
    show_menu
    read choice
    case $choice in
        1)
            apply_optimizations
            ;;
        2)
            clear 
            echo "Exiting without making changes."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter 1 or 2."
            sleep 2 
            ;;
    esac
done
