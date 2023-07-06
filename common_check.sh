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
echo "chrony check" 2>&1 | tee -a $LOGFILE
echo "------------------" 2>&1 | tee -a $LOGFILE
sleep 1
systemctl status chronyd 2>&1 | tee -a $LOGFILE
chronyc sources 2>&1 | tee -a $LOGFILE
echo -e "\n" 2>&1 | tee -a $LOGFILE

echo "###########################################" 2>&1 | tee -a $LOGFILE
echo "disk check" 2>&1 | tee -a $LOGFILE
echo "------------------" 2>&1 | tee -a $LOGFILE
sleep 1
df -h 2>&1 | tee -a $LOGFILE
echo -e "\n" 2>&1 | tee -a $LOGFILE

echo "###########################################" 2>&1 | tee -a $LOGFILE
echo "selinux check" 2>&1 | tee -a $LOGFILE
echo "------------------" 2>&1 | tee -a $LOGFILE
sleep 1
getenforce 2>&1 | tee -a $LOGFILE
echo -e "\n" 2>&1 | tee -a $LOGFILE

echo "###########################################" 2>&1 | tee -a $LOGFILE
echo "swap check" 2>&1 | tee -a $LOGFILE
echo "------------------" 2>&1 | tee -a $LOGFILE
sleep 1
free -m 2>&1 | tee -a $LOGFILE
echo -e "\n" 2>&1 | tee -a $LOGFILE

echo "======================== hostname: $HOSTNAME = end ==========================" 2>&1 | tee -a $LOGFILE
echo -e "\n" 2>&1 | tee -a $LOGFILE
