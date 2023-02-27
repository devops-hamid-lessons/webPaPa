# Web PaPa

WebPaPa is a simple Script to ssh a remote ubuntu machine and config it as a apache server.

## Requirement

Requirement         | Specification
------------------- | ----------------------
OS                  | Ubuntu (all versions)
Language            | bash


## How to use

Simply run:

```bash
sudo su
./runInstaller.sh --sshUsername 'username' --sshIp ip --sshPassword 'Pass'  --sshPort port
Example: ./runInstaller.sh  --sshUsername 'ubuntu' --sshIp 5.5.5.5  --sshPassword '123'  --sshPort 1212
```
### params:
#### --sshUsername, --sshIp, --sshPassword, and --sshPort params specify ssh credentials to connect the remote server.
- Note that using --sshPort is not required, if you do not use a port number to ssh to the remote server. 

