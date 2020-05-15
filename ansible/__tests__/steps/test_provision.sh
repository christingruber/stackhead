#!/bin/bash
# IP address in environment "IP"
# Domain in environment "DOMAIN"
INVENTORY_PATH=ansible/__tests__/inventory.yml

sed -e "s/\${ipaddress}/${IP}/" ansible/__tests__/inventory.dist.yml > $INVENTORY_PATH

# Install dependencies
ansible-galaxy install -r ansible/requirements/requirements.yml

# Provision server
ansible-playbook ansible/server-provision.yml -i $INVENTORY_PATH -vvv
# Nginx smoketest already included in playbook