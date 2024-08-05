#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Variables
SYSADMIN_USER="sysadmin"
SYSADMIN_PASSWORD="password" # Thay đổi mật khẩu cho phù hợp
NEW_HOSTNAME="newhostname"   # Thay đổi hostname cho phù hợp
DNS_SERVER="8.8.8.8"         # Thay đổi DNS server cho phù hợp
LOG_FILE="/var/log/command.log" # File log lưu trữ các lệnh

# 1. Update and install initial tools
echo "Updating and installing initial tools..."
apt-get update
apt-get install -y curl wget vim git net-tools

# 2. Change hostname
echo "Changing hostname to $NEW_HOSTNAME..."
hostnamectl set-hostname $NEW_HOSTNAME
echo "$NEW_HOSTNAME" > /etc/hostname
sed -i 's/127\.0\.1\.1.*/127.0.0.1   '"$NEW_HOSTNAME"'/' /etc/hosts

# 3. Configure DNS
echo "Configuring DNS server to $DNS_SERVER..."
echo "nameserver $DNS_SERVER" > /etc/resolv.conf

# 4. Set timezone to Vietnam
echo "Setting timezone to Vietnam..."
timedatectl set-timezone Asia/Ho_Chi_Minh

# 5. Create sysadmin user with sudo privileges
echo "Creating sysadmin user..."
useradd -m -s /bin/bash -G sudo $SYSADMIN_USER
echo "$SYSADMIN_USER:$SYSADMIN_PASSWORD" | chpasswd

# 6. Install Docker
echo "Installing Docker..."
apt-get update
apt-get install -y docker.io

# Start and enable Docker
echo "Starting and enabling Docker..."
systemctl start docker
systemctl enable docker

# Configure Docker daemon
echo "Configuring Docker daemon..."
cat <<EOF > /etc/docker/daemon.json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2"
}
EOF

# Restart Docker to apply the changes
echo "Restarting Docker..."
systemctl restart docker

# 7. Optimize TCP/IP settings
echo "Optimizing TCP/IP settings..."
cat <<EOF >> /etc/sysctl.conf
# TCP/IP optimization
net.core.somaxconn = 1024
net.core.netdev_max_backlog = 5000
net.ipv4.tcp_max_syn_backlog = 4096
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_keepalive_time = 300
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_syncookies = 1
EOF

# Apply sysctl settings
sysctl -p

# 8. Increase file descriptors limit
echo "Increasing file descriptors limit..."
cat <<EOF >> /etc/security/limits.conf
* soft nofile 100000
* hard nofile 100000
EOF

# 9. Optimize kernel parameters
echo "Optimizing kernel parameters..."
cat <<EOF >> /etc/sysctl.conf
# Kernel parameter optimization
vm.swappiness = 10
vm.dirty_ratio = 15
vm.dirty_background_ratio = 5
EOF

# Apply sysctl settings again
sysctl -p

# 10. Enable command logging for all users
echo "Enabling command logging..."
cat <<EOF >> /etc/profile
# Log all user commands
export PROMPT_COMMAND='history -a'
export HISTTIMEFORMAT="%d/%m/%y %T "
export HISTFILESIZE=50000
export HISTSIZE=50000
shopt -s histappend

function log_command {
  if [[ \$(whoami) != "root" ]]; then
    logger -p local1.notice -t bash -i -- "COMMAND: \$(history 1 | sed 's/^ *[0-9]* *//')"
  fi
}
PROMPT_COMMAND="log_command; \$PROMPT_COMMAND"
EOF

# Setup syslog to log these commands to a specific file
cat <<EOF >> /etc/rsyslog.d/50-default.conf
local1.*                        $LOG_FILE
EOF

# Restart rsyslog to apply changes
systemctl restart rsyslog

echo "All configurations applied successfully."
