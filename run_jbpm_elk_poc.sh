#!/bin/bash
JBPM_PERSISTENT_DIR=$1
JBPM_BBVA_IMAGE_VERSION=$2
JBPM_IMAGE_NAME=jizuzquiza/jbpm-bbva-holding
JBPM_CONTAINER_NAME=jbpm-bbva-holding
JBOSS_HOME=/opt/jboss/wildfly
ELASTICSEARCH_IMAGE_NAME=docker.elastic.co/elasticsearch/elasticsearch
ELASTICSEARCH_CONTAINER_NAME=elasticsearch
ELASTICSEARCH_VERSION=7.6.0
KIBANA_IMAGE_NAME=docker.elastic.co/kibana/kibana
KIBANA_CONTAINER_NAME=kibana
KIBANA_VERSION=7.6.0

if [ -z "$JBPM_PERSISTENT_DIR" ]
then
        JBPM_PERSISTENT_DIR=$HOME/jbpm-container-persistence
fi

if [ -z "$JBPM_BBVA_IMAGE_VERSION" ]
then
        JBPM_BBVA_IMAGE_VERSION=latest
fi

docker stop $JBPM_CONTAINER_NAME
docker rm $JBPM_CONTAINER_NAME

mkdir -p $JBPM_PERSISTENT_DIR/logs
mkdir -p $JBPM_PERSISTENT_DIR/repositories/mvn_home
mkdir -p $JBPM_PERSISTENT_DIR/data
mkdir -p $JBPM_PERSISTENT_DIR/user_group_data

docker pull $JBPM_IMAGE_NAME:$JBPM_BBVA_IMAGE_VERSION 

#if [ "$(docker network ls | grep -w jbpm-elk-poc 2> /dev/null)" == "" ]
#then
    docker network create jbpm-elk-poc
#fi

docker run -p 8080:8080 -p 8001:8001 -p 8082:8082 -p 9990:9990 \
    --mount source=jbpm-logs,target=$JBOSS_HOME/standalone/log/ \
    --mount source=jbpm-repositories,target=/opt/jboss/.m2/ \
    --mount source=jbpm-repositories,target=/opt/jboss/repositories/ \
    --mount source=jbpm-data,target=/opt/jboss/data/ \
    --mount source=jbpm-user-group-data,target=$JBOSS_HOME/standalone/configuration/ \
    --network jbpm-elk-poc \
    -d --name $JBPM_CONTAINER_NAME $JBPM_IMAGE_NAME:$JBPM_BBVA_IMAGE_VERSION

#if [ "$(docker ps -a | awk '{print $NF}' | grep -w elasticsearch | cat 2> /dev/null)" == "" ]
#then
#    if [ $(docker images -q $ELASTICSEARCH_IMAGE_NAME:$ELASTICSEARCH_VERSION 2> /dev/null)" == "" ]
#    then
        docker pull $ELASTICSEARCH_IMAGE_NAME:$ELASTICSEARCH_VERSION
#    fi

    docker run -p 9200:9200 -p 9300:9300 --name $ELASTICSEARCH_CONTAINER_NAME --network jbpm-elk-poc \
        -d -e "discovery.type=single-node" -e "xpack.security.enabled=false" $ELASTICSEARCH_IMAGE_NAME:$ELASTICSEARCH_VERSION
#fi

#if [ "$(docker ps -a | awk '{print $NF}' | grep -w kibana | cat 2> /dev/null)" == "" ]
#then
#    if [ "$(docker images -q  2> /dev/null)" == "" ]
#    then
        docker pull $KIBANA_IMAGE_NAME:$KIBANA_VERSION
#    fi

    docker run -p 5601:5601 --name $KIBANA_CONTAINER_NAME --network jbpm-elk-poc \
        -d $KIBANA_IMAGE_NAME:$KIBANA_VERSION
#fi

