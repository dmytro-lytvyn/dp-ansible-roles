# Data Platform: Ansible Roles
## Roles description

These Ansible roles install and configure the components of the Data Platform:
- Data Input server with Apache NiFi for data ingestion, Confluent Schema Registry (along with Zookeeper and Kafka to store schemas) for event schema validation, Landoo Schema Registry UI for user-friendly schema editing, and Kafdrop as a simple Kafka UI.
- (TBD) Data Streaming server with Confluent Zookeeper and Kafka to stream the ingested events for further processing.
- (TBD) Data Processing and Storage server, with Cloudera Manager, Spark and Hadoop (or Hortonworks, to be decided later).
- (TBD) Data Output and Presentation server, with Cloudera Hue interface for Hive and Impala for data querying, and Redash for data visualisation and dashboards.

For demonstration purposes, the components will be installed on the servers named rogue-1, rogue-2 etc. Later they can be assigned proper domain names in DNS.

## How to use this project
### Preparing a brand new host to be managed with Ansible

Generate a private key on your managing computer if needed, and copy it to the root user of the remote server (no passphrase). This is only needed if your new server was not provisioned with your key already in place:

```bash
$ ssh-keygen
$ ssh-copy-id root@rogue-1 # assuming you only have root access at first
```

Log in to the remote server with your private key (-i key_path is needed only if it's not in a default location):

```bash
$ ssh root@rogue-1 -i ~/id_rsa
```

Set a preferred host name if needed:

```bash
$ sudo vi /etc/hostname
$ sudo vi /etc/hosts
$ sudo reboot
```

Install Python:

```bash
$ sudo apt install python
```

At this step, you no longer need to log in to your server and do anything manually, all further installation will be done by running the Ansible playbook.

### Setting up Ansible on your managing computer

Install Ansible (on Ubuntu):

```bash
$ sudo add-apt-repository -y ppa:ansible/ansible
$ sudo apt update
$ sudo apt install ansible
```

Install Ansible (on Mac OS):

```bash
# Install Homebrew:
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Add Local directory to PATH in ~/.bash_profile:
$ export PATH="/usr/local/opt/python/libexec/bin:$PATH"

# Install Python with Homebrew:
$ brew install python

# Install Ansible with pip:
$ pip install --user ansible

# Include Python Local directory to PATH in ~/.bash_profile:
export PATH="/usr/local/opt/python/libexec/bin:/Users/d.lytvyn/Library/Python/3.7/bin:$PATH" 
```

Prepare custom config in a separate directory of your choice:

```bash
$ cp -R /etc/ansible ~/data-platform
$ cd ~/data-platform
```

Add your remote servers to Ansible hosts file, under data-platform group:

```bash
$ vi hosts
```

```ini
[data-platform]
something ansible_host=something.freemyip.com ansible_port=55522 # For a dynamic IP host, non-standard port
rogue-1 ansible_host=123.123.123.123
rogue-2 ansible_host=123.123.123.124
```

Set hosts file location in a local Ansible config:

```bash
$ vi ansible.cfg
```

```ini
[defaults]
inventory      = hosts
```

### Ansible commands

List the inventory:

```bash
$ ansible --user=username --list-hosts all
```

Test the configuration:

```bash
$ ansible --user=username --module-name=ping all
```

Execute shell commands:

```bash
$ ansible --user=username --module-name=shell --args='df -h' all
```

Execute commands with sudo and a password:

```bash
$ ansible --user=username --become --ask-become-pass --module-name=shell --args='whoami' all
```

Execute commands with a passwordless sudo:

```bash
$ ansible --user=username --become --module-name=shell --args='whoami' all
```

Copy the sample Ansible playbook provided in the repository and update it to your needs:

```bash
$ cp data-platform-sample.yml data-platform.yml
$ vi data-platform.yml
```

Run the Ansible playbook for the first time for one of the servers, when no passwordless sudo available, only root user exists (which will add a default user with a passwordless sudo and disable root login), and only the roles specified by tags in a playbook:

```bash
$ ansible-playbook --user=root data-platform.yml --limit=rogue-1 --tags="basic,firewall"
```

For every consequent run, as a normal user, without a password, applying all roles defined in a playbook:

```bash
$ ansible-playbook --user=username data-platform.yml
```

You can to a test run (without applying any changes) using the parameter --check:

```bash
$ ansible-playbook --user=username data-platform.yml --check
```
