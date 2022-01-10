# INSTALL FLASK APP
# CONFIGURE FLASK WITH NGINX & WSGI SERVER FOR PRODUCTION
# CONFIGURE APP TO AUTO RESTART ON REBOOT OR FAILURE

echo "[+] Installing utilities"
apt update -y

echo "[+] Installing Dependencies"
apt install -y curl zip unzip 
apt install python3-pip -y
apt install nginx python3-pip python3-dev build-essential libssl-dev libffi-dev python3-setuptools checkinstall -y
apt install python3-venv -y
pip3 install pyinstaller
pip3 install flask


echo "[+] Adding Website"
mkdir /var/www/app
unzip -o app.zip -d /var/www/app
cd /var/www/app/ && chmod +x app.py && chmod +x wsgi.py

python3 -m venv pixel
source pixel/bin/activate
pip3 install wheel
pip3 install uwsgi flask
deactivate


cat <<EOF > /var/www/app/app.ini
[uwsgi]
module = wsgi:app

master = true
processes = 5

socket = app.sock
chmod-socket = 660
vacuum = true

die-on-term = true
EOF



cat <<EOF > /etc/systemd/system/app.service
[Unit]
Description=uWSGI instance to serve myproject
After=network.target

[Service]
User=app
Group=www-data
WorkingDirectory=/var/www/app
ExecStart=/var/www/app/app/bin/uwsgi --ini app.ini

[Install]
WantedBy=multi-user.target
EOF


cat <<EOF > /etc/nginx/sites-available/app
server {
    listen 8080;
    server_name localhost;
	 location / {
		include uwsgi_params;
        uwsgi_pass unix:/var/www/app/app.sock;
    }
}
EOF

chown -R app:www-data /var/www/app
cd /var/www/app && chown app:www-data *


ln -s /etc/nginx/sites-available/app /etc/nginx/sites-enabled
systemctl restart nginx

systemctl daemon-reload
systemctl start app
systemctl enable app
