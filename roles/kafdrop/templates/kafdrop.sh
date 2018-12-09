#!/bin/bash

java -jar /opt/kafdrop/kafdrop.jar --zookeeper.connect={{ kafdrop_zookeeper_host_name }}:{{ kafdrop_zookeeper_port }}
