#!/bin/bash

JBPM_PERSISTENT_DIR=/home/jaime/development/docker/jbpm

docker run -p 8080:8080 -p 8001:8001 -p 8082:8082 -p 9990:9990 \
    -v $JBPM_PERSISTENT_DIR/logs/:/opt/jboss/wildfly/standalone/log/:Z \
    -v $JBPM_PERSISTENT_DIR/repositories/mvn_home/:/opt/jboss/.m2/:Z \
    -v $JBPM_PERSISTENT_DIR/repositories/:/opt/jboss/repositories/:Z \
    -v $JBPM_PERSISTENT_DIR/data/:/opt/jboss/data/:Z \
    -d --name jbpm-bbva-holding jbpm-bbva-holding:0.1
