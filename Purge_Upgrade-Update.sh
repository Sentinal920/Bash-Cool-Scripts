# Purges the unattended-upgrades package and disable auto update/upgrades
apt remove unattended-upgrades -y
sed -i 's/Update-Package-Lists "1"/Update-Package-Lists "0"/gI' /etc/apt/apt.conf.d/20auto-upgrades
sed -i 's/Unattended-Upgrade "1"/Unattended-Upgrade "0"/gI' /etc/apt/apt.conf.d/20auto-upgrades
