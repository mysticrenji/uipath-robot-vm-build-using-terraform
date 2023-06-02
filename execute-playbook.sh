#!/bin/sh

cd ansible
if [ -f "$host" ] ; then
    rm "$host"
fi
echo "[$host]" | tee -a $host;
echo "$host ansible_user=$username ansible_password=$password ansible_connection=winrm ansible_winrm_server_cert_validation=ignore" | tee -a $host;
export ANSIBLE_HOST_KEY_CHECKING=False;
ansible-playbook -i $host $playbook --extra-vars "storageaccountname=$storageaccountname filesharename=$filesharename storageaccountkeys=$storageaccountkeys orchestratorurl=$orchestratorurl machinekey=$machinekey" -vvvv
