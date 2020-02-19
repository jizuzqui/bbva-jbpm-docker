#!/bin/bash
JBPM_PERSISTENT_DIR=$1
JBPM_BBVA_IMAGE_VERSION=$2
JBPM_IMAGE_NAME=jbpm-bbva-holding

if [ -z "$JBPM_PERSISTENT_DIR" ]
then
        JBPM_PERSISTENT_DIR=$HOME/jbpm-container-persistence
fi

if [ -z "$JBPM_BBVA_IMAGE_VERSION" ]
then
        JBPM_BBVA_IMAGE_VERSION=1.0
fi

docker stop $JBPM_IMAGE_NAME
docker rm $JBPM_IMAGE_NAME
docker rmi $JBPM_IMAGE_NAME

mkdir -p $JBPM_PERSISTENT_DIR/logs
mkdir -p $JBPM_PERSISTENT_DIR/repositories/mvn_home
mkdir -p $JBPM_PERSISTENT_DIR/data

docker build -t $JBPM_IMAGE_NAME:$JBPM_BBVA_IMAGE_VERSION ./community_image/

docker run -p 8080:8080 -p 8001:8001 -p 8082:8082 -p 9990:9990 \
    -v $JBPM_PERSISTENT_DIR/logs/:/opt/jboss/wildfly/standalone/log/:Z \
    -v $JBPM_PERSISTENT_DIR/repositories/mvn_home/:/opt/jboss/.m2/:Z \
    -v $JBPM_PERSISTENT_DIR/repositories/:/opt/jboss/repositories/:Z \
    -v $JBPM_PERSISTENT_DIR/data/:/opt/jboss/data/:Z \
    -d --name jbpm-bbva-holding $JBPM_IMAGE_NAME:$JBPM_BBVA_IMAGE_VERSION
