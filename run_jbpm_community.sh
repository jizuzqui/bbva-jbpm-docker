#!/bin/bash

docker run -p 8080:8080 -p 8001:8001 -p 8082:8082 --name jbpm-bbva-holding jbpm-bbva-holding:0.1
# 	-v /opt/jboss/wb_git:/opt/jboss/wildfly/bin/.niogit:Z \
