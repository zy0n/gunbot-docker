#!/bin/bash

# Specify the directory you want to check
storage=/data
workdir=/opt/gunbot
tmpdir=$workdir/tmp
gunbotmp=$tmpdir/gunthy-linux

# CONTAINER
gunbotdir=$workdir/gunthy_linux
gunbotcore=$gunbotdir/gunthy-linux

# PERSIST
gunbothome=$storage/gunthy_linux
gunbotbin=$gunbothome/gunthy-linux

# Check if the directory is empty
if [ "$(ls -A $storage)" ]; then
  if [ -d $gunbotdir ]; then 
    # means we recreated a container, with existing storage attached
    echo "New container found"

    mv $gunbotcore $gunbotbin
    rm -rf $gunbotdir
    chmod +x $gunbotbin
  fi

  echo "Starting Gunbot..."
  cd $gunbothome
  $gunbotbin

else
  echo "Directory is empty. Moving $gunbotdir to $storage..."
  echo "Installing Gunbot... This may take a few minutes."
  openssl req -config $workdir/ssl.config -newkey rsa:2048 -nodes -keyout $gunbotdir/localhost.key -x509 -days 365 -out $gunbotdir/localhost.crt -extensions v3_req 2>/dev/null
  sed -i 's/"https": false/"https": true/' $gunbotdir/config.js
  
  chmod +x $gunbotcore
  mv $gunbotdir $storage

  echo "Install complete."
  echo "Starting Gunbot..."
  cd $gunbothome
  $gunbotbin

fi