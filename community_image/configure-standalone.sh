#!/bin/bash
      
JBOSS_CLI=$JBOSS_HOME/bin/jboss-cli.sh
JBOSS_MODE=standalone
JBOSS_CONFIG=standalone.xml

 
function wait_for_server() {
  until `$JBOSS_CLI -c "ls /deployment" &> /dev/null`; do
    sleep 1
 done
}

echo "=> Starting WildFly server"
$JBOSS_HOME/bin/$JBOSS_MODE.sh -c standalone.xml >/dev/null &
      
echo "=> Waiting for the server to boot"
wait_for_server
      
echo "=> Executing the commands"
$JBOSS_CLI -c --file=`dirname "$0"`/standalone-config.cli
     
echo "=> Shutting down WildFly"
if [ "$JBOSS_MODE" = "standalone" ]; then
  $JBOSS_CLI -c ":shutdown"
else
  $JBOSS_CLI -c "/host=*:shutdown"
fi
