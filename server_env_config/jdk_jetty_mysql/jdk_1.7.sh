#!/bin/bash

if [ $UID -ne 0 ];
then
    echo "Please run with super user"
    exit 1
fi

DOWNLOAD_DIR="./downloads"
JDK_FILE="$DOWNLOAD_DIR/jdk-7u80-linux-x64.tar.gz"
JDK_DURL="http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-linux-x64.tar.gz"
JDK_INSTALL_DIR="/usr/local/java"
JDK_ROOT_FOLDER="jdk1.7.0_80"
JDK_STD_FOLDER="/usr/java"
PROFILE="/etc/profile"

if [ ! -d "$DOWNLOAD_DIR" ];
then
    echo "ehll"
    mkdir -p "$DOWNLOAD_DIR"
fi

if [ ! -f $JDK_FILE ]; then
    wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" $JDK_DURL -O ./$JDK_FILE
fi

if [ $? -ne 0 ];
then 
    echo "Download $JDK_FILE failed."
    exit 1
else
    echo "Download $JDK_FILE success."
fi

if [ ! -f "$JDK_FILE" ];
then
    echo "$JDK_FILE Not Found."
    exit 1
fi

if [ ! -d "$JDK_INSTALL_DIR" ];
then
    echo "ehll"
    mkdir -p "$JDK_INSTALL_DIR"
fi

tar -zxvf $JDK_FILE -C $JDK_INSTALL_DIR

if [ ! -d "$JDK_STD_FOLDER" ];
then
    mkdir -p "$JDK_STD_FOLDER"
fi

ln -s "$JDK_INSTALL_DIR/$JDK_ROOT_FOLDER" "$JDK_STD_FOLDER/jdk"

echo "JAVA_HOME=$JDK_STD_FOLDER/jdk" >> "$PROFILE" 
echo "PATH=$JDK_STD_FOLDER/jdk/bin:$PATH" >> "$PROFILE"
echo "CLASSPATH=.:$JDK_STD_FOLDER/jdk/lib/rt.jar:$JDK_STD_FOLDER/jdk/lib/tools.jar" >> "$PROFILE"
source "$PROFILE"

java -version
