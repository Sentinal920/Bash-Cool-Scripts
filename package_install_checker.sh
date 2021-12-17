# Performs a check and prints a message showing whether or not the tree, grc, open-vm-tools, net-tools, ifupdown, openssh-server packages are installed 
echo "[+] Package checks"
for package in tree grc open-vm-tools net-tools ifupdown openssh-server
do
    status=$(dpkg-query -W -f='${Status}' $package 2>/dev/null)
    echo $package ": " $status
done
