# Hive role for Ansible

https://www.cloudera.com/documentation/enterprise/5-14-x/topics/cdh_ig_cdh5_install.html#topic_4_4_2
https://www.cloudera.com/documentation/enterprise/5-12-x/topics/cdh_ig_cdh5_install.html#topic_4_4_1__section_dfx_p51_nj
https://www.cloudera.com/documentation/enterprise/5-14-x/topics/cdh_ig_hive_installation.html

```bash
echo "deb [arch=amd64] http://archive.cloudera.com/cdh5/ubuntu/xenial/amd64/cdh xenial-cdh5 contrib" > /etc/apt/sources.list.d/cloudera.list
wget https://archive.cloudera.com/cdh5/ubuntu/xenial/amd64/cdh/archive.key -O archive.key
sudo apt-key add archive.key
apt update
grep ^Package: /var/lib/apt/lists/archive.cloudera.com_*_Packages
apt install hive hive-metastore hive-server2
```
