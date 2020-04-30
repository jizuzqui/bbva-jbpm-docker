#!/bin/bash

inotifywait -m -e close_write,create,modify,move_self /opt/jboss/mock-server/services/mockServicesDefinitions.json |
while read -r filename events; do
     /opt/jboss/mock-server/start-mock-server.sh
done

