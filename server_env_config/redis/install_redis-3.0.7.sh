#!/bin/bash

if [ $UID -ne 0 ];
then
    echo "Please run with super user"
    exit 1
fi

DOWNLOAD_DIR="./downloads"
REDIA_FILE="$DOWNLOAD_DIR/redis-3.0.7.tar.gz"
REDIA_DURL="http://download.redis.io/releases/redis-3.0.7.tar.gz"
REDIA_INSTALL_DIR="/usr/local/redis"
REDIA_ROOT_FOLDER="redis-3.0.7"
REDIA_STD_FOLDER="/usr/redis"
PROFILE="/etc/profile"

if [ ! -d "$DOWNLOAD_DIR" ];
then
    echo "ehll"
    mkdir -p "$DOWNLOAD_DIR"
fi

if [ ! -f $REDIA_FILE ]; then
    wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" $REDIA_DURL -O ./$REDIA_FILE
fi

if [ $? -ne 0 ];
then 
    echo "Download $REDIA_FILE failed."
    exit 1
else
    echo "Download $REDIA_FILE success."
fi

if [ ! -f "$REDIA_FILE" ];
then
    echo "$REDIA_FILE Not Found."
    exit 1
fi

if [ ! -d "$REDIA_INSTALL_DIR" ];
then
    echo "ehll"
    mkdir -p "$REDIA_INSTALL_DIR"
fi

tar -zxvf $REDIA_FILE -C $REDIA_INSTALL_DIR

if [ ! -d "$REDIA_STD_FOLDER" ];
then
    mkdir -p "$REDIA_STD_FOLDER"
fi

ln -s "$REDIA_INSTALL_DIR/$REDIA_ROOT_FOLDER" "$REDIA_STD_FOLDER/3.0.7"

cd "$REDIA_INSTALL_DIR/$REDIA_ROOT_FOLDER"

if [ `uname -m` == "x86_64" ];then
make
else
make 32bit
fi

ifubuntu=$(cat /proc/version | grep ubuntu)
if [ "$ifubuntu" != "" ] && [ "$if14" != "" ];then
  cd src && make all
fi
