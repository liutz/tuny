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
DB_ROOT_FOLDER_64="mysql-5.6.21-linux-glibc2.5-x86_64"
DB_ROOT_FOLDER_32="mysql-5.6.21-linux-glibc2.5-i686"
DB_STD_FOLDER="/usr/db"

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
  if [ ! -f $MYSQL_FILE_64 ];then
	 wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" $MYSQL_DURL_64 -O $MYSQL_FILE_64
  fi
  tar -xzvf $MYSQL_FILE_64
  
  if [ ! -d "$DB_STD_FOLDER/$DB_ROOT_FOLDER_64" ];
  then
    mkdir -p "$DB_STD_FOLDER/$DB_ROOT_FOLDER_64"
  fi  
  
  mv $DOWNLOAD_DIR/$DB_ROOT_FOLDER_64/* $DB_STD_FOLDER/$DB_ROOT_FOLDER_64
else  
  if [ ! -f $MYSQL_FILE_32 ];then
	 wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" $MYSQL_DURL_32 -O $MYSQL_FILE_32
  fi
  tar -xzvf $MYSQL_FILE_32
  
  if [ ! -d "$DB_STD_FOLDER/$DB_ROOT_FOLDER_32" ];
  then
    mkdir -p "$DB_STD_FOLDER/$DB_ROOT_FOLDER_32"
  fi  
  mv $DOWNLOAD_DIR/$DB_ROOT_FOLDER_32/* $DB_STD_FOLDER/$DB_ROOT_FOLDER_32
fi


