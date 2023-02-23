#! /bin/bash

usage() {
echo "
********** This script gets ssh credentials and executes the script specified by scriptToRun variable on the remote machine **********
Call it this way: ./runInstaller.sh --sshUsername 'username' --sshIp ip --sshPassword 'Pass'  --sshPort port
Example: ./runInstaller.sh  --sshUsername 'ubuntu' --sshIp 5.5.5.5  --sshPassword '123'  --sshPort 1212
Use --sshPort only if you need it for your ssh connection
*******************************************************************************************************************************************
"
}
scriptToRun='./installer.sh'

# Check if user is root
if [[ $EUID -ne 0 ]]; then
  echo ""
  echo "*** Error: Please run as superuser."
  exit 1
fi

index=0
while [[ "${1:-}" != "" ]]; do
  case "$1" in
    --sshUsername )               connectionUsername="$2";   shift;;
    --sshIp )                     connectionIp="$2";   shift;;
    --sshPassword )               connectionPass="$2";   shift;;
    --sshPort )                   connectionPort="$2";   shift;;
    --help )                      usage;       exit;; # Quit and show usage
  esac
  shift
done

rm -f /root/.ssh/known_hosts

if [[ -z ${connectionUsername} || -z ${connectionIp} || -z ${connectionPass} ]]; then
  echo ""
  echo " *** Error: --serverUsername, --serverIp, and --serverPassword are required fields. Please provide all of them."
  exit 1
fi

ping -c 2 ${connectionIp} >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
  echo ""
  echo "*** Error: Entered Ip address is not reachable. Please correct it."
#  exit 1
fi


if [[ -z ${connectionPort} ]]; then
  connectionStatement="${connectionUsername}@${connectionIp}"
else
  connectionStatement="-p ${connectionPort} ${connectionUsername}@${connectionIp}"
fi

command -v sshpass >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
  apt-get update
  sudo apt install sshpass -y
  if [[ $? -ne 0 ]]; then
    echo ""
    echo "*** Error: Unable to install sshpass. Install sshpass and then try again."
    exit 1
  fi
fi

# sshpass provides a way to pass "ssh password" in command line and perform ssh with a single line command.
# using "'bash -s' < " makes it possible to run ${scriptToRun} with its arguments on the remote machine
sshpass -p ${connectionPass} ssh -o StrictHostKeyChecking=no ${connectionStatement} 'bash -s' "$connectionPass" <${scriptToRun}
returnCode=$(echo $?)
exit "$returnCode"
