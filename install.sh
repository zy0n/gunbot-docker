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

# cd $gunbotdir

# Check if the directory is empty
if [ "$(ls -A $storage)" ]; then
  # We have gunthy storage, link the executable.

  if [ -d $tmpdir ]; then
    # we have the temporary directory, move it
    echo "Temp directory found"
    mv $gunbotmp $gunbotbin
  elif [ -d $gunbotdir ]; then # means we recreated a container, with existing storage attached
    echo "New container found"

    mv $gunbotcore $gunbotbin
    rm -rf $gunbotdir
    chmod +x $gunbotbin
  fi



  echo "Starting Gunbot..."
  cd $gunbothome
  $gunbotbin
  # when we get here, execution has ended. cleanup container.
  echo "Performing Cleanup..."

  mv $gunbotbin $tmpdir
else
  echo "Directory is empty. Moving $gunbotdir to $storage..."

  openssl req -config /opt/gunbot/ssl.config -newkey rsa:2048 -nodes -keyout $gunbotdir/localhost.key -x509 -days 365 -out $gunbotdir/localhost.crt -extensions v3_req 2>/dev/null
  sed -i 's/"https": false/"https": true/' $gunbotdir/config.js
  
  chmod +x $gunbotcore
  mv $gunbotdir $storage

  echo "Install complete."
  echo "Starting Gunbot..."
  cd $gunbothome
  $gunbotbin
  # when it gets here execution of gunbot ended. cleanup container
  mkdir $tmpdir
  mv $gunbotbin $tmpdir
  echo "Performing Cleanup..."

fi