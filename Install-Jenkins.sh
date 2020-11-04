echo "[+] Installing Jenkins at port 8080"

#Installing Jenkins on port 8080

echo "START" >> /tmp/status.txt
sudo chmod 777 /tmp/status.txt
apt update -y
sudo apt install openjdk-11-jdk -y
wget -qO - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update -y
sudo apt install jenkins -y
echo "CONFIG DONE" >> /tmp/status.txt 
sudo apt-get update -y >> /tmp/status.txt
echo "APT-GET INSTALL DONE" >> /tmp/status.txt

# will wait for jenkins start up
response=""
key=""
while [ `echo $response | grep 'Authenticated' | wc -l` = 0 ]; do
  key=`sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
  echo $key >> /tmp/status.txt
  response=`sudo java -jar /var/cache/jenkins/war/WEB-INF/lib/cli-2.249.2.jar -auth admin:$key -s http://localhost:8080  who-am-i`
  sudo echo $response
  sudo echo "Jenkins not started, wait for 2s"
  sleep 2
done >> /tmp/status.txt
echo "Jenkins started" >> /tmp/status.txt
echo "Install Plugins" >> /tmp/status.txt

# install plugins with jenkins-cli
for package in ant blueocean blueocean-autofavorite build-timeout email-ext ghprb gradle jacoco workflow-aggregator pipeline-github-lib sbt ssh-slaves subversion timestamper ws-cleanup; do sudo sh -c "sudo java -jar /var/cache/jenkins/war/WEB-INF/lib/cli-2.249.2.jar -auth admin:$key -s http://localhost:8080 install-plugin $package  >> /tmp/status.txt"; done;  
echo "PLUGINS INSTALL DONE" >> /tmp/status.txt

#Display Initial Password
key=`sudo cat /var/lib/jenkins/secrets/initialAdminPassword`

#Adding new user and password
echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("admin", "MyStr0nGp@@sw0rD")' | java -jar /var/cache/jenkins/war/WEB-INF/lib/cli-2.249.2.jar -auth admin:$key -s http://localhost:8080/ groovy =

# restart jenkins
/etc/init.d/jenkins restart  >> /tmp/status.txt
echo "ALL DONE" >> /tmp/status.txt

