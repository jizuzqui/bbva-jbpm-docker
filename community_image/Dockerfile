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

# Create directory for persistent repositories (git, maven, kie, db, users)
RUN mkdir -p /opt/jboss/repositories/git
RUN mkdir -p /opt/jboss/repositories/maven
RUN mkdir -p /opt/jboss/repositories/kie
RUN mkdir -p /opt/jboss/data
RUN mkdir $JBOSS_HOME/standalone/configuration/users_groups_data
RUN chown -R jboss:jboss $JBOSS_HOME/standalone/configuration/users_groups_data
RUN chown -R jboss:jboss /opt/jboss/data
RUN chown -R jboss:jboss /opt/jboss/repositories

USER jboss

RUN mv $JBOSS_HOME/standalone/deployments/*war $JBOSS_HOME/standalone/ 

RUN $JBOSS_HOME/configure-standalone.sh

RUN mv $JBOSS_HOME/standalone/*.war $JBOSS_HOME/standalone/deployments/

RUN touch $JBOSS_HOME/standalone/deployments/business-central.war.dodeploy
RUN touch $JBOSS_HOME/standalone/deployments/kie-server.war.dodeploy

RUN $JBOSS_HOME/bin/add-user.sh -a -u controllerUser -p password@1 -g kie-server,rest-all
RUN $JBOSS_HOME/bin/add-user.sh -a -u jbpmAdmin -p password@1 -g admin,kie-server,rest-all

ENV JAVA_OPTS="$JAVA_OPTS -Xms1500m -Xmx2572m -XX:MetaspaceSize=512m -XX:MaxMetaspaceSize=768m -Djava.net.preferIPv4Stack=true"

####### RUNNING JBPM-WB ############
WORKDIR $JBOSS_HOME/bin/

RUN sed  '/bash/a java -Dh2.bindAddress=0.0.0.0 -jar /opt/jboss/wildfly/modules/system/layers/base/com/h2database/h2/main/h2-1.4.193.jar -tcp -web -webAllowOthers &' -i start_jbpm-wb.sh
RUN sed  '/bash/a echo \"Initializing h2 server...\"' -i start_jbpm-wb.sh
CMD ["./start_jbpm-wb.sh"]

