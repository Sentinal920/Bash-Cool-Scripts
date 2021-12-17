# Ensure that the root user is NOT allowed to SSH in with a 'password'
vech=$(cat /etc/ssh/sshd_config | grep -iP PermitRootLogin | awk '{print;}') 

for i in $vech:
do   
if [[ $i = 'PermitRootLogin' ]]
then
  sed -i "s/$i.*/PermitRootLogin prohibit-password/gI" /etc/ssh/sshd_config
  echo 
fi
done
