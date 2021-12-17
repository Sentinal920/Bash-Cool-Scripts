# Performs a check to ensure that only ports 22 and 80 are listening externally
echo "[+] Check open ports"
echo "Externally running ports"
ss -tl | awk '$4~/0.0.0.0/ {print $4}'

sudo ufw default deny incoming &> /dev/null
sudo ufw default allow outgoing &> /dev/null
sudo ufw allow ssh &> /dev/null
sudo ufw allow 80/tcp &> /dev/null
sudo ufw enable &> /dev/null
echo -e '\n'
echo 'Added Firewall Rule to only allow port 22 and 80'



# ALLOW OUTBOUND RULES

# sudo ufw allow out to 192.168.x.x port 22
# sudo ufw reload
