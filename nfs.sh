#!/bin/bash
Namespace=$NS
cat /home/ubuntu/output.json | jq -r '@sh "export ipaddress=\(.jump_public_ip.value)"' > env.sh
source env.sh
SCRIPT="[[ -d /viya-share ]] && echo -e \"\nGood to go!\" || echo -e \"\nWhoa! Stop! Something is wrong with the NFS server.\""
SCRIPTNS="mkdir /viya-share/NS && cd /viya-share/NS && mkdir bin data homes astores && ls -l /viya-share /viya-share/NS"
HOSTS=$ipaddress
SCR=${SCRIPTNS/NS/$Namespace}
SCR=${SCR/NS/$Namespace}
SCR=${SCR/NS/$Namespace}
echo $SCR
USERNAMES="jumpuser"
sshpass ssh -o StrictHostKeyChecking=no -l $USERNAMES $HOSTS "${SCRIPT}"
sshpass ssh -o StrictHostKeyChecking=no -l $USERNAMES $HOSTS "${SCR}"

