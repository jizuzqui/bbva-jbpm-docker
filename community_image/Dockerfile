FROM jboss/jbpm-server-full:latest

USER jboss

LABEL maintainer="jaime.izuzquiza@bbva.com"

RUN rm $JBOSS_HOME/standalone/deployments/business-central.war.* \
        $JBOSS_HOME/standalone/deployments/kie-server.war.*

COPY ./configure-standalone.sh $JBOSS_HOME
COPY ./standalone-config.cli $JBOSS_HOME

# RUN rm $JBOSS_HOME/standalone/deployments/*.dodeploy

USER root

RUN chmod 755 $JBOSS_HOME/configure-standalone.sh
RUN chown jboss:root $JBOSS_HOME/configure-standalone.sh

USER jboss

RUN mv $JBOSS_HOME/standalone/deployments/*war $JBOSS_HOME/standalone/ 

RUN $JBOSS_HOME/configure-standalone.sh

RUN mv $JBOSS_HOME/standalone/*.war $JBOSS_HOME/standalone/deployments/

RUN touch $JBOSS_HOME/standalone/deployments/business-central.war.dodeploy
RUN touch $JBOSS_HOME/standalone/deployments/kie-server.war.dodeploy

#COPY ./templates/maven-settings.xml $HOME/.m2/settings.xml

# COPY etc/META-INF/kie-deployment-descriptor.xml $JBOSS_HOME/standalone/deployments/kie-execution-server.war/WEB-INF/classes/META-INF/kie-deployment-descriptor.xml
# COPY ./jboss-deployment-structure.xml $JBOSS_HOME/standalone/deployments/kie-execution-server.war/WEB-INF/

RUN $JBOSS_HOME/bin/add-user.sh -a -u controllerUser -p password@1 -g kie-server,rest-all
RUN $JBOSS_HOME/bin/add-user.sh -a -u jbpmAdmin -p password@1 -g admin,kie-server,rest-all

ENV JAVA_OPTS="$JAVA_OPTS -Xms1500m -Xmx2572m -XX:MetaspaceSize=512m -XX:MaxMetaspaceSize=768m -Djava.net.preferIPv4Stack=true"

# ENV EXTRA_OPTS="$EXTRA_OPTS \
#	-Dorg.kie.server.id=jbpm-development-server  \
#	-Dorg.kie.server.location=http://localhost:8080/kie-server/services/rest/server  \
#	-Dorg.kie.server.controller=http://localhost:8080/business-central/rest/controller  \
#	-Dorg.kie.server.controller.user=controllerUser  \
#	-Dorg.kie.server.controller.pwd=password@1  \
#	-Dorg.kie.server.user=controllerUser \
#	-Dorg.kie.server.pwd=password@1 \
#	-Dorg.jbpm.task.cleanup.enabled=false \
#	-Dappformer.experimental.features=true \
#	-Dorg.kie.prometheus.server.ext.disabled=true \
#	-Dorg.kie.server.persistence.ds=java:jboss/datasources/XjBPMDS"

####### RUNNING JBPM-WB ############
WORKDIR $JBOSS_HOME/bin/
CMD ["./start_jbpm-wb.sh"]
