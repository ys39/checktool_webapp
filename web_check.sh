#!/bin/sh

if [ ${EUID:-${UID}} != 0 ]; then
  echo "Please execute as root user."
  exit 1
fi

# variable
MYFILENAME=$(basename $0 .sh)
HOSTNAME=`hostname`
DATE=`date +%Y%m%d`
DATETIME=`date +%Y%m%d-%H%M`
FILEDIR=$(cd $(dirname $0); pwd)
LOGDIR="${FILEDIR}/log/${DATE}"
LOGFILE="${LOGDIR}/${MYFILENAME}_${HOSTNAME}_${DATETIME}.log"

# mkdir
[ ! -d ${LOGDIR} ] && mkdir -p ${LOGDIR} ; chmod 777 ${FILEDIR}/log

#execute command
echo -e "\n" 2>&1 | tee -a $LOGFILE
echo "======================== hostname: $HOSTNAME = start ==========================" 2>&1 | tee -a $LOGFILE
echo "execute date : $DATETIME" 2>&1 | tee -a $LOGFILE
echo -e "\n" 2>&1 | tee -a $LOGFILE
sleep 1

echo "###########################################" 2>&1 | tee -a $LOGFILE
echo "apache check" 2>&1 | tee -a $LOGFILE
echo "------------------" 2>&1 | tee -a $LOGFILE
sleep 1
systemctl status httpd 2>&1 | tee -a $LOGFILE
echo -e "\n" 2>&1 | tee -a $LOGFILE

echo "###########################################" 2>&1 | tee -a $LOGFILE
echo "php-fpm check" 2>&1 | tee -a $LOGFILE
echo "------------------" 2>&1 | tee -a $LOGFILE
sleep 1
systemctl status php-fpm 2>&1 | tee -a $LOGFILE
echo -e "\n" 2>&1 | tee -a $LOGFILE

echo "###########################################" 2>&1 | tee -a $LOGFILE
echo "mount check" 2>&1 | tee -a $LOGFILE
echo "------------------" 2>&1 | tee -a $LOGFILE
sleep 1
df -h 2>&1 | tee -a $LOGFILE
echo -e "\n" 2>&1 | tee -a $LOGFILE
cat /etc/fstab 2>&1 | tee -a $LOGFILE
echo -e "\n" 2>&1 | tee -a $LOGFILE

echo "###########################################" 2>&1 | tee -a $LOGFILE
echo "rpcbind check" 2>&1 | tee -a $LOGFILE
echo "------------------" 2>&1 | tee -a $LOGFILE
sleep 1
systemctl status rpcbind 2>&1 | tee -a $LOGFILE
echo -e "\n" 2>&1 | tee -a $LOGFILE

echo "###########################################" 2>&1 | tee -a $LOGFILE
echo "cron check" 2>&1 | tee -a $LOGFILE
echo "------------------" 2>&1 | tee -a $LOGFILE
sleep 1
cat /etc/cron.d/* 2>&1 | tee -a $LOGFILE
echo -e "\n" 2>&1 | tee -a $LOGFILE

echo "======================== hostname: $HOSTNAME = end ==========================" 2>&1 | tee -a $LOGFILE
echo -e "\n" 2>&1 | tee -a $LOGFILE