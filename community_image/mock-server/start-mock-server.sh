#!/bin/bash

MOCKSERVER_PROCESS="$(ps -ef | grep mockserver | grep -v grep | awk '{print $2}')"
 
kill -9 $MOCKSERVER_PROCESS 
java -Dmockserver.initializationJsonPath=/opt/jboss/mock-server/services/mockServicesDefinitions.json -jar /opt/jboss/mock-server/mockserver-netty-5.10.0-jar-with-dependencies.jar -serverPort 1080 -logLevel INFO &
