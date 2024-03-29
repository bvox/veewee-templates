#!/bin/bash
cat > /etc/init.d/ssh_gen_host_keys <<EOF
#! /bin/sh
### BEGIN INIT INFO
# Provides:             ssh_gen_host_keys
# Required-Start:        
# Required-Stop:         
# Default-Start:        2 3 4 5
# Default-Stop:         0 1 6        
# Short-Description:    OpenBSD Secure Shell server
### END INIT INFO
# chmod +x /etc/init.d/ssh_gen_host_keys
# update-rc.d ssh_gen_host_keys start 15 2 3 4 5 . stop 85 0 1 6 ."

set -e

# /etc/init.d/ssh_gen_host_keys: create new host keys for the "secure shell(tm)" daemon 

case "$1" in
  start)
   if [ ! -e /etc/ssh/ssh_host_rsa_key ]  || [ ! -e /etc/ssh/ssh_host_dsa_key ] || 
      [ ! -e /etc/ssh/ssh_host_rsa_key.pub ] || 
      [ ! -e /etc/ssh/ssh_host_dsa_key.pub ]; then
       rm -f /etc/ssh/ssh_host_*
       ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa > /dev/null 2>&1
       ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa > /dev/null 2>&1
       #ubuntu 11.x 
       sal=;
       [ 1 -eq 0 ] && ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa  > /dev/null 2>&1
   fi
  ;;
  stop)
   # 
  ;;
  *)
   echo "Usage: /etc/init.d/ssh_host_rsa_key {start} "  
   exit 1;
esac

exit 0;
EOF

chmod +x /etc/init.d/ssh_gen_host_keys
update-rc.d ssh_gen_host_keys start 15 2 3 4 5 . stop 85 0 1 6 . > /dev/null 2>&1
rm /etc/ssh/ssh_host_* 2>/dev/null
exit
