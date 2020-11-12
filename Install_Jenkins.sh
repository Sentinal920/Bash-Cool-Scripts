echo "[+] Installing Jenkins at port 8080"

apt update -y
sudo apt install openjdk-11-jdk -y
wget -qO - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

sudo apt update -y
sudo apt install jenkins -y
sudo apt-get update -y 

response=""
key=""
JenkinsCli=`echo /var/cache/jenkins/war/WEB-INF/lib/cli-*`

# Checking if Jenkins is up or not by sending who-am-i
while [ `echo $response | grep 'Authenticated' | wc -l` = 0 ]; do
  sudo echo "Starting Jenkins..."
  sleep 20
  key=`sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
  echo $key 
  response=`sudo java -jar $JenkinsCli -auth admin:$key -s http://localhost:8080  who-am-i`
done

echo "Jenkins started"

# Installiong Some Suggested Plugins, It can also be configured via GUI using browser
echo "Installing Plugins" 
for package in ant blueocean blueocean-autofavorite build-timeout email-ext ghprb gradle jacoco workflow-aggregator pipeline-github-lib sbt ssh-slaves subversion timestamper ws-cleanup; do sudo sh -c "sudo java -jar $JenkinsCli -auth admin:$key -s http://localhost:8080 install-plugin $package";done;  

# Adding a new admin user
key=`sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
echo "Adding Username:Password"
echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("admin", "password")' | java -jar $JenkinsCli -auth admin:$key -s http://localhost:8080/ groovy =
echo "Restart jenkins"
/etc/init.d/jenkins restart  

echo "ALL DONE" 

# All done! Fireup your browser, visit localhost:8080 and login with your new admin user
