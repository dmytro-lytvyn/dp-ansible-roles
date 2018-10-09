#!/bin/bash

# fail whole script if anything fails
set -e

# cron clears all environment variables, we need PATH for ufw
export PATH="/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin"

function log { # $1=text
  echo "$(date +"%Y-%m-%d %H:%M:%S.%N"): $1"
}

HOSTNAME="{{ firewall_dynamic_ip_hostname }}"
IPADDR_FILE="{{ firewall_dynamic_ip_config_path }}"

if [ -f $IPADDR_FILE ]; then
  OLD_IP=$(cat $IPADDR_FILE)
else
  OLD_IP=""
fi

CURRENT_IP=$(host $HOSTNAME | cut -f4 -d' ')

if [ "$CURRENT_IP" = "$OLD_IP" ] ; then
  log "IP address ($CURRENT_IP) has not changed"

else
  if [ ! -z $OLD_IP ] ; then
    ufw delete allow from $OLD_IP to any
    log "Old dynamic IP ($OLD_IP) has been removed from ufw"
  fi

  ufw allow from $CURRENT_IP to any
  echo $CURRENT_IP > $IPADDR_FILE

  log "New dynamic IP ($CURRENT_IP) has been added to ufw"
fi
