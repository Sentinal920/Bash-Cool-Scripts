#This script would help you to install jenkins_2.249.2


echo "[+] Installing Jenkins at port 8080"

apt update -y

sudo apt install openjdk-8-jdk -y
wget -qO - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

echo "Downloading Jenkins"
echo "Please wait...."

# Jenkins server is unstable and most of the time down providing 503 temporary unavailable error
# So better to use google drive link where i've uploaded the package jenkins_2.249.2 instead of jenkins server.
# cd /tmp && wget https://get.jenkins.io/debian-stable/jenkins_2.249.2_all.deb

cd /tmp && curl -L "https://drive.google.com/uc?export=download&id=1w6c3cjUPrIzvNaTIIzo3JuLv9OLk2BTH" > jenkins_2.249.2_all.deb


echo "Installing Jenkins..."
dpkg -i jenkins_2.249.2_all.deb &>/dev/null
apt-get -y install -f  &>/dev/null

sudo apt update -y 
 
response=""
key=""
JenkinsCli=`echo /var/cache/jenkins/war/WEB-INF/lib/cli-*`

while [ `echo $response | grep 'Authenticated' | wc -l` = 0 ]; do
  sudo echo "Starting Jenkins..."
  sleep 20
  key=`sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
  echo $key 
  response=`sudo java -jar $JenkinsCli -auth admin:$key -s http://localhost:8080  who-am-i`
done

echo "Jenkins started"

key=`sudo cat /var/lib/jenkins/secrets/initialAdminPassword`

echo "Adding new User"
echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("admin", "P@$$W0rD")' | java -jar $JenkinsCli -auth admin:$key -s http://localhost:8080/ groovy =

# Disable initial setup wizard and suggested plugins wizard
echo "Disabling Setup and Plugin Wizard..."
sudo sed -i 's#<installStateName>NEW.*#<installStateName>RUNNING<\/installStateName>#g' /var/lib/jenkins/config.xml
sleep 5
echo "Restarting jenkins"
/etc/init.d/jenkins restart  

echo "Jenkins Configured Successfully" 
