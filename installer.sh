#! /bin/bash

# *** save params for root bash
echo "$1" >passFile
# *** become root user
cat passFile | sudo -S ls >/dev/null
sudo su
if [[ $? -ne 0 ]]; then
  echo "*** Unable to become the root user"
  echo "**** configuration failed :((("
  rm -f passFile
  exit 1
  exit 1
fi
rm -f passFile

rm -f /var/lib/apt/lists/lock
rm -f /var/cache/apt/archives/lock
rm -f /var/lib/dpkg/lock*
rm -f /var/lib/dpkg/updates/*
apt update -y
dpkg --configure -a
# *** update repo
apt-get update -y
if [[ $? -ne 0 ]]; then
  apt-get --fix-broken install -y
  apt-get update -y
  if [[ $? -ne 0 ]]; then
    echo "*** Error: Unable to update repository."
    echo "*** configuration failed :((("
    exit 1
    exit 1
  fi

fi

# *** install and config apache2
DEBIAN_FRONTEND=noninteractive apt install apache2  -yq
if [[ $? -ne 0 ]]; then
  echo "*** Error: Unable to install apache2"
  echo "*** configuration failed :((("
  exit 1
  exit 1
fi

ufw allow 'Apache Full'

{
echo "<html>"
echo "<head>"
echo "  <title> Ubuntu rocks! </title>"
echo "</head>"
echo "<body>"
echo "  <p> I'm running this website on an Ubuntu Server server! </p>"
echo "</body>"
echo "</html>"
} > /var/www/html/index.html

systemctl restart apache2

if [[ $? -ne 0 ]]; then
  echo "*** Error: Unable to restart apache2"
  echo "*** configuration failed :((("
  exit 1
  exit 1
fi

echo "***********************************"
echo "*** configuration is complete :))))"
echo "***********************************"
