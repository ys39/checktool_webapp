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
DBMASTERHOSTNAME="dbmaster"
DBSLAVEHOSTNAME="dbslave"

# mkdir
[ ! -d ${LOGDIR} ] && mkdir -p ${LOGDIR} ; chmod 777 ${FILEDIR}/log

#execute command
echo -e "\n" 2>&1 | tee -a $LOGFILE
echo "======================== hostname: $HOSTNAME = start ==========================" 2>&1 | tee -a $LOGFILE
echo "execute date : $DATETIME" 2>&1 | tee -a $LOGFILE
echo -e "\n" 2>&1 | tee -a $LOGFILE
sleep 1

echo "###########################################" 2>&1 | tee -a $LOGFILE
echo "mysql check" 2>&1 | tee -a $LOGFILE
echo "------------------" 2>&1 | tee -a $LOGFILE
sleep 1
systemctl status mysqld 2>&1 | tee -a $LOGFILE
echo -e "\n" 2>&1 | tee -a $LOGFILE

# dbmasterのみ#########################################################
if [ ${HOSTNAME} -eq ${DBMASTERHOSTNAME} ]; then
  echo "###########################################" 2>&1 | tee -a $LOGFILE
  echo "mysql replication(master) check" 2>&1 | tee -a $LOGFILE
  echo "------------------" 2>&1 | tee -a $LOGFILE
  sleep 1
  mysql --defaults-extra-file=./mysqlpass.cnf -e 'show master status\G' 2>&1 | tee -a $LOGFILE
  echo -e "\n" 2>&1 | tee -a $LOGFILE
fi
# dbmasterのみ#########################################################

# dbslaveのみ#########################################################
if [ ${HOSTNAME} -eq ${DBSLAVEHOSTNAME} ]; then
  echo "###########################################" 2>&1 | tee -a $LOGFILE
  echo "memcached check" 2>&1 | tee -a $LOGFILE
  echo "------------------" 2>&1 | tee -a $LOGFILE
  sleep 1
  systemctl status memcached 2>&1 | tee -a $LOGFILE
  echo -e "\n" 2>&1 | tee -a $LOGFILE

  echo "###########################################" 2>&1 | tee -a $LOGFILE
  echo "mysql replication(slave) check" 2>&1 | tee -a $LOGFILE
  echo "------------------" 2>&1 | tee -a $LOGFILE
  sleep 1
  mysql --defaults-extra-file=./mysqlpass.cnf -e 'show slave status\G' 2>&1 | tee -a $LOGFILE
  echo -e "\n" 2>&1 | tee -a $LOGFILE
fi
# dbslaveのみ#########################################################

echo "======================== hostname: $HOSTNAME = end ==========================" 2>&1 | tee -a $LOGFILE
echo -e "\n" 2>&1 | tee -a $LOGFILE
