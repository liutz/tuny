#!/bin/bash
if [ $UID -ne 0 ];
then
    echo "Please run with super user"
    exit 1
fi
DOWNLOAD_DIR="./downloads"
JETTY_FILE="$DOWNLOAD_DIR/jetty-distribution-9.2.15.v20160210.tar.gz"
JETTY_DURL="http://download.eclipse.org/jetty/9.2.15.v20160210/dist/jetty-distribution-9.2.15.v20160210.tar.gz"
JETTY_INSTALL_DIR="/usr/local/jetty"
JETTY_ROOT_FOLDER="jetty-distribution-9.2.15.v20160210"
SERVER_STD_FOLDER="/usr/server"
PROFILE="/etc/profile"

if [ ! -d "$DOWNLOAD_DIR" ];
then
    echo "ehll"
    mkdir -p "$DOWNLOAD_DIR"
fi

if [ ! -f $JETTY_FILE ]; then
    wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" $JETTY_DURL -O ./$JETTY_FILE
fi

if [ $? -ne 0 ];
then 
    echo "Download $JETTY_FILE failed."
    exit 1
else
    echo "Download $JETTY_FILE success."
fi

if [ ! -f "$JETTY_FILE" ];
then
    echo "$JETTY_FILE Not Found."
    exit 1
fi

if [ ! -d "$JETTY_INSTALL_DIR" ];
then
    echo "ehll"
    mkdir -p "$JETTY_INSTALL_DIR"
fi

tar -zxvf $JETTY_FILE -C $JETTY_INSTALL_DIR

if [ ! -d "$SERVER_STD_FOLDER" ];
then
    mkdir -p "$SERVER_STD_FOLDER"
fi

if [ ! -L $SERVER_STD_FOLDER/$JETTY_ROOT_FOLDER ];
then
    ln -s $JETTY_INSTALL_DIR/$JETTY_ROOT_FOLDER $SERVER_STD_FOLDER/$JETTY_ROOT_FOLDER
fi

echo "JETTY_HOME=$SERVER_STD_FOLDER/$JETTY_ROOT_FOLDER" >> "$PROFILE" 
echo "PATH=$SERVER_STD_FOLDER/$JETTY_ROOT_FOLDER/bin:$PATH" >> "$PROFILE"
source "$PROFILE"


