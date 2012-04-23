#!/bin/bash
echo "Initial cleanup..."
apt-get update  > /dev/null
apt-get -y install sudo > /dev/null
passwd -d root
passwd -l root
echo > /etc/resolv.conf
echo "Removing unused packages and caches..."
apt-get --purge clean > /dev/null
apt-get -y remove linux-headers-$(uname -r) build-essential
apt-get autoremove --purge -y > /dev/null
apt-get clean
rm -f /var/cache/apt/*.bin > /dev/null 2>&1
rm -f /var/lib/apt/lists/* > /dev/null 2>&1
rm -f /var/lib/apt/lists/partial/* > /dev/null 2>&1
rm -f /var/log/*.gz > /dev/null 2>&1
echo "Cleaning log files..."
find /var/log/ -name "*log" -type f |xargs  -I % sh -c "cat /dev/null > %"
[ -f /var/log/wtmp ] && cat /dev/null > /var/log/wtmp
[ -f /var/log/syslog ] && cat /dev/null > /var/log/syslog
[ -f /var/log/auth.log ] && cat /dev/null > /var/log/auth.log
[ -f /root/.bash_history ] && cat /dev/null > /root/.bash_history

# Removing leftover leases and persistent rules
kill `pidof dhclient3` 2> /dev/null
echo "cleaning up dhcp leases"
rm /var/lib/dhcp/*

# Make sure Udev doesn't block our network
echo "cleaning up udev rules"
rm /etc/udev/rules.d/70-persistent-net.rules
mkdir /etc/udev/rules.d/70-persistent-net.rules
rm -rf /dev/.udev/
rm /lib/udev/rules.d/75-persistent-net-generator.rules

exit
