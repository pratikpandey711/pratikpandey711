#!/bin/bash -e

if [ "$UID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Only run it if we can (ie. on Ubuntu/Debian)
if [ -x /usr/bin/apt-get ]; then
  wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_6.0-3+debian11_all.deb
  dpkg -i zabbix-release_6.0-3+debian11_all.deb
  apt-get update
  apt-get -y install zabbix-agent sysv-rc-conf
  sysv-rc-conf zabbix-agent on
  sed -i 's/Server=127.0.0.1/Server=192.168.56.103/' /etc/zabbix/zabbix_agentd.conf
  sed -i 's/ServerActive=127.0.0.1/ServerActive=192.168.56.103/' /etc/zabbix/zabbix_agentd.conf
  HOSTNAME=`hostname` && sed -i "s/Hostname=Zabbix\ server/Hostname=$HOSTNAME/" /etc/zabbix/zabbix_agentd.conf
  service zabbix-agent restart
fi

# Only run it if we can (ie. on RHEL/CentOS)
if [ -x /usr/bin/yum ]; then
  yum -y update
  rpm -Uvh https://repo.zabbix.com/zabbix/6.0/rhel/8/x86_64/zabbix-release-6.0-2.el8.noarch.rpm
  yum -y install zabbix-agent
  chkconfig zabbix-agent on
  sed -i 's/Server=127.0.0.1/Server=192.168.56.103/' /etc/zabbix/zabbix_agentd.conf
  sed -i 's/ServerActive=127.0.0.1/ServerActive=192.168.56.103/' /etc/zabbix/zabbix_agentd.conf
  HOSTNAME=`hostname` && sed -i "s/Hostname=Zabbix\ server/Hostname=$HOSTNAME/" /etc/zabbix/zabbix_agentd.conf
  service zabbix-agent restart
fi
