#!/bin/bash
if [ $UID -ne 0 ];
then
    echo "Please run with super user"
    exit 1
fi

DOWNLOAD_DIR="./downloads"
MYSQL_FILE_64="$DOWNLOAD_DIR/mysql-5.6.21-linux-glibc2.5-x86_64.tar.gz"
MYSQL_FILE_32="$DOWNLOAD_DIR/mysql-5.6.21-linux-glibc2.5-i686.tar.gz"
MYSQL_DURL_64="http://zy-res.oss-cn-hangzhou.aliyuncs.com/mysql/mysql-5.6.21-linux-glibc2.5-x86_64.tar.gz"
MYSQL_DURL_32="http://zy-res.oss-cn-hangzhou.aliyuncs.com/mysql/mysql-5.6.21-linux-glibc2.5-i686.tar.gz"
DB_ROOT_FOLDER="mysql-5.6.21-linux-glibc2.5"
DB_STD_FOLDER="/usr/db"
DB_LOG="$DB_STD_FOLDER/$DB_ROOT_FOLDER/log"

if [ ! -d "$DB_LOG" ];
then
    echo "ehll"
    mkdir -p "$DB_LOG"
fi

if [ ! -d "$DOWNLOAD_DIR" ];
then
    echo "ehll"
    mkdir -p "$DOWNLOAD_DIR"
fi

ifubuntu=$(cat /proc/version | grep ubuntu)
if14=$(cat /etc/issue | grep 14)

if [ `uname -m` == "x86_64" ];then
machine=x86_64
else
machine=i686
fi

if [ $machine == "x86_64" ];then
  if [ ! -f $MYSQL_FILE_64 ];
  then wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" $MYSQL_DURL_64 -O $MYSQL_FILE_64
  fi
  
  tar -xzvf $MYSQL_FILE_64 -C $DOWNLOAD_DIR
  
  if [ ! -d "$DB_STD_FOLDER/$DB_ROOT_FOLDER" ];
  then mkdir -p "$DB_STD_FOLDER/$DB_ROOT_FOLDER"
  fi
  
  mv $DOWNLOAD_DIR/mysql-5.6.21-linux-glibc2.5-x86_64/* $DB_STD_FOLDER/$DB_ROOT_FOLDER
else
  if [ ! -f $MYSQL_FILE_32 ];then
         wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" $MYSQL_DURL_32 -O $MYSQL_FILE_32
  fi
  tar -xzvf $MYSQL_FILE_32 -C $DOWNLOAD_DIR

  if [ ! -d "$DB_STD_FOLDER/$DB_ROOT_FOLDER" ];
  then
    mkdir -p "$DB_STD_FOLDER/$DB_ROOT_FOLDER"
  fi
  mv $DOWNLOAD_DIR/mysql-5.6.21-linux-glibc2.5-i686 $DB_STD_FOLDER/$DB_ROOT_FOLDER
fi

if [ "$ifubuntu" != "" ] && [ "$if14" != "" ];then
	mv /etc/mysql/my.cnf /etc/mysql/my.cnf.bak
fi

group="mysql"
user="mysql"
mycnf="/etc/my.cnf"
PROFILE="/etc/profile"

#create group if not exists
egrep "^$group" /etc/group >& /dev/null  
if [ $? -ne 0 ]  
then  
    groupadd $group  
fi

#create user if not exists  
egrep "^$user" /etc/passwd >& /dev/null  
if [ $? -ne 0 ]  
then  
    useradd -g $group $user  
fi

if [ -f $mycnf ];then
     rm $mycnf
fi

$DB_STD_FOLDER/$DB_ROOT_FOLDER/scripts/mysql_install_db --datadir=$DB_STD_FOLDER/$DB_ROOT_FOLDER/data/ --basedir=$DB_STD_FOLDER/$DB_ROOT_FOLDER --user=mysql
chown -R mysql:mysql $DB_STD_FOLDER/$DB_ROOT_FOLDER/
chown -R mysql:mysql $DB_STD_FOLDER/$DB_ROOT_FOLDER/data/
chown -R mysql:mysql $DB_LOG
\cp -f $DB_STD_FOLDER/$DB_ROOT_FOLDER/support-files/mysql.server /etc/init.d/mysqld
sed -i 's#^basedir=$#basedir=/usr/db/mysql-5.6.21-linux-glibc2.5#' /etc/init.d/mysqld
sed -i 's#^datadir=$#datadir=/usr/db/mysql-5.6.21-linux-glibc2.5/data#' /etc/init.d/mysqld
\cp -f $DB_STD_FOLDER/$DB_ROOT_FOLDER/support-files/my-default.cnf /etc/my.cnf
echo "expire_logs_days = 5" >> /etc/my.cnf
echo "max_binlog_size = 1000M" >> /etc/my.cnf
sed -i 's#skip-external-locking#skip-external-locking\nlog-error=/usr/db/mysql-5.6.21-linux-glibc2.5/log/error.log#' /etc/my.cnf
chmod 755 /etc/init.d/mysqld
/etc/init.d/mysqld start

echo "PATH=$DB_STD_FOLDER/$DB_ROOT_FOLDER/bin:$PATH" >> "$PROFILE"
source "$PROFILE"
