# Basic system role for Ansible

Includes the following actions:
- Add/update a default user with a specified password (see defaults)
- Enable passwordless sudo for the default user
- Disable root login via SSH
- Install some tools (htop, screen, curl) and Midnight Commander with updated config (see files/mc)
