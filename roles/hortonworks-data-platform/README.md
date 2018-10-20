# Hortonworks Data Platform role for Ansible

##Installation

To apply the role like this (given the servers were already configured with "basic" and "firewall" rules):

```bash
$ ansible-playbook --user=username data-platform.yml --limit=rogue-2,rogue-3 --tags "hortonworks-data-platform,java"
```

After applying the role you should have Oracle Java 1.8, Postgres and Ambari Server installed and running, available at port 8080.

When installing a cluster, you will have a warning:

```
Firewall is running on the following hosts. Please configure the firewall to allow communications on the ports documented in the Configuring Ports section of the Ambari documentation.
ufw Running			Running on 2 hosts
```

You can ignore it, because "firewall" ansible role already took care of adding the firewall rules to allow all traffic between the DataPlatform nodes.

##Hortonworks Dataflow

If you want to install ![Hortonworks Dataflow instead on top of Hortonworks Data Platform](https://docs.hortonworks.com/HDPDocuments/HDF3/HDF-3.2.0/installing-hdf/content/installing_the_hdf_management_pack_on_an_hdf_cluster.html), run the following commands:

```bash
$ cp -r /var/lib/ambari-server/resources /var/lib/ambari-server/resources.backup
$ cd /tmp && wget http://public-repo-1.hortonworks.com/HDF/ubuntu16/3.x/updates/3.1.1.0/tars/hdf_ambari_mp/hdf-ambari-mpack-3.1.1.0-35.tar.gz
$ ambari-server install-mpack --mpack=/tmp/hdf-ambari-mpack-3.1.1.0-35.tar.gz --verbose
```

After restarting Ambari Server, it could not use HDF stack (logs are in /var/log/ambari-server/ambari-server.log):

```
2018-10-19 12:47:50,582  INFO [ambari-client-thread-35] AmbariMetaInfo:1423 - Stack HDF-3.1 is not valid, skipping VDF: The service 'AMBARI_INFRA' in stack 'HDF:2.0' extends a non-existent service: 'common-services/AMBARI_INFRA/0.1.0'
```

Therefore it required a patch:

```bash
$ vi /var/lib/ambari-server/resources/mpacks/hdf-ambari-mpack-3.1.1.0-35/stacks/HDF/2.0/services/AMBARI_INFRA/metainfo.xml
```

```xml
<metainfo>
  <schemaVersion>2.0</schemaVersion>
  <services>
    <service>
      <name>AMBARI_INFRA</name>
      <extends>common-services/AMBARI_INFRA_SOLR/0.1.0</extends>
    </service>
  </services>
</metainfo>
```

Restart Ambari Server and you can install a cluster of HDF:

```bash
$ ambari-server restart
```
