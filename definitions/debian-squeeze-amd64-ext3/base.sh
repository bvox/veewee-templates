# Update the box
apt-get -y update
apt-get -y install curl unzip nfs-client

# Set up sudo
cp /etc/sudoers /etc/sudoers.orig
sed -i -e 's/%sudo ALL=(ALL) ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers

# Create the user vagrant with password vagrant
useradd -G sudo -p $(perl -e'print crypt("bvox", "bvox")') -m -s /bin/bash -N bvox 

# Tweak sshd to prevent DNS resolution (speed up logins)
echo 'UseDNS no' >> /etc/ssh/sshd_config
