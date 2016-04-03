#!/bin/bash

if [ $UID -ne 0 ];
then
    echo "Please run with super user"
    exit 1
fi

DOWNLOAD_DIR="./downloads"
MAVEN_FILE="$DOWNLOAD_DIR/apache-maven-3.3.9-bin.tar.gz"
MAVEN_DURL="http://mirrors.hust.edu.cn/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz"
MAVEN_INSTALL_DIR="/usr/local/maven"
MAVEN_ROOT_FOLDER="apache-maven-3.3.9"
MAVEN_STD_FOLDER="/usr/maven"
PROFILE="/etc/profile"

if [ ! -d "$DOWNLOAD_DIR" ];
then
    echo "ehll"
    mkdir -p "$DOWNLOAD_DIR"
fi

if [ ! -f $MAVEN_FILE ]; then
    wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" $MAVEN_DURL -O ./$MAVEN_FILE
fi

if [ $? -ne 0 ];
then 
    echo "Download $MAVEN_FILE failed."
    exit 1
else
    echo "Download $MAVEN_FILE success."
fi

if [ ! -f "$MAVEN_FILE" ];
then
    echo "$MAVEN_FILE Not Found."
    exit 1
fi

if [ ! -d "$MAVEN_INSTALL_DIR" ];
then
    echo "ehll"
    mkdir -p "$MAVEN_INSTALL_DIR"
fi

tar -zxvf $MAVEN_FILE -C $MAVEN_INSTALL_DIR

if [ ! -d "$MAVEN_STD_FOLDER" ];
then
    mkdir -p "$MAVEN_STD_FOLDER"
fi

ln -s "$MAVEN_INSTALL_DIR/$MAVEN_ROOT_FOLDER" "$MAVEN_STD_FOLDER/mvn"

echo "PATH=$MAVEN_STD_FOLDER/mvn/bin:$PATH" >> "$PROFILE"
source "$PROFILE"
