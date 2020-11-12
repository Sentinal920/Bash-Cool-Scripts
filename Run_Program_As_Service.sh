# Running a calc.py file as a service in linux

echo 'description "calc"' > /etc/init/calc.conf
echo "start on stopped rc RUNLEVEL=[2345]" >> /etc/init/calc.conf
echo "respawn" >> /etc/init/calc.conf
echo "exec python /root/Calculator/calc.py" >> /etc/init/calc.conf

echo "[Unit]" > /lib/systemd/system/calc.service
echo "Description=Demo calc Service" >> /lib/systemd/system/calc.service

echo "[Install]" >> /lib/systemd/system/calc.service
echo "WantedBy=multi-user.target" >> /lib/systemd/system/calc.service

echo "[Service]" >> /lib/systemd/system/calc.service
echo "User=root" >> /lib/systemd/system/calc.service
echo "PermissionsStartOnly=true" >> /lib/systemd/system/calc.service
echo "ExecStart=/root/Calculator/calc.py" >> /lib/systemd/system/calc.service
echo "TimeoutSec=600" >> /lib/systemd/system/calc.service
echo "Restart=on-failure" >> /lib/systemd/system/calc.service
echo "RuntimeDirectoryMode=755" >> /lib/systemd/system/calc.service

# Make calc.py file executable
cd /root/Calculator && chmod +x calc.py

# Reload systemctl and start the service
sudo systemctl daemon-reload
sudo systemctl start calc

# Check Status of service
sudo systemctl status calc

# Add automatic start on boot:
sudo systemctl enable calc
