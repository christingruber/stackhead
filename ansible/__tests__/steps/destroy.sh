#!/bin/bash
# Ansible inventory path in environment "INVENTORY_PATH"

# This test destroys a deployed project on the target server
# IMPORTANT: This must run after test_deploy.sh!

INVENTORY_PATH="${GITHUB_ACTION_PATH}/ansible/__tests__/inventory.yml"
TEST=1 ansible-playbook "${GITHUB_ACTION_PATH}/ansible/playbooks/application-destroy.yml" -i "${INVENTORY_PATH}" --extra-vars "project_name=container" -vv