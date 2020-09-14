FROM jboss/jbpm-server-full:latest

USER root

COPY ./configure-standalone.sh $JBOSS_HOME
COPY ./standalone-config.cli $JBOSS_HOME

RUN rm $JBOSS_HOME/standalone/deployments/business-central.war.* $JBOSS_HOME/standalone/deployments/kie-server.war.* \
        && mv $JBOSS_HOME/standalone/deployments/kie-server.war $JBOSS_HOME/standalone/ \
        && mkdir -p $JBOSS_HOME/standalone/deployments/kie-server.war \
        && unzip $JBOSS_HOME/standalone/kie-server.war -d $JBOSS_HOME/standalone/deployments/kie-server.war \
        && rm -rf $JBOSS_HOME/standalone/*.war \
	&& mkdir -p /opt/jboss/repositories/git \
        && mkdir -p /opt/jboss/repositories/maven \
        && mkdir -p /opt/jboss/repositories/kie\
        && mkdir -p /opt/jboss/data \
        && mkdir -p /opt/jboss/git-hooks \
        && mkdir -p /opt/jboss/mock-server \
	&& mkdir $JBOSS_HOME/standalone/configuration/users_groups_data \
        && yum install -y epel-release && yum -y install git inotify-tools && yum -y clean all \
        && chmod 755 $JBOSS_HOME/configure-standalone.sh \
        && chown jboss:jboss $JBOSS_HOME/configure-standalone.sh \
        && touch $JBOSS_HOME/standalone/deployments/business-central.war.dodeploy \
        && touch $JBOSS_HOME/standalone/deployments/kie-server.war.dodeploy \
        && touch $JBOSS_HOME/standalone/deployments/jbpm-casemgmt.war.dodeploy \
        && $JBOSS_HOME/bin/add-user.sh -a -u controllerUser -p password@1 -g kie-server,rest-all \
        && $JBOSS_HOME/bin/add-user.sh -a -u jbpmAdmin -p password@1 -g admin,kie-server,rest-all \
	&& $JBOSS_HOME/bin/add-user.sh admin password@1 \
	&& $JBOSS_HOME/configure-standalone.sh \
	&& rm -rf $JBOSS_HOME/standalone/tmp \
	&& rm -rf $JBOSS_HOME/standalone/data \
	&& sed '/bash/a java -Dh2.bindAddress=0.0.0.0 -jar /opt/jboss/wildfly/modules/system/layers/base/com/h2database/h2/main/h2-1.4.197.jar -tcp -web -webAllowOthers &' -i start_jbpm-wb.sh \
        && sed '/bash/a /opt/jboss/mock-server/start-mock-server.sh' -i start_jbpm-wb.sh \
        && sed '/bash/a /opt/jboss/mock-server/watch-mock-services-definitions.sh &' -i start_jbpm-wb.sh \
        && sed '/bash/a echo \"Initializing h2 server...\"' -i start_jbpm-wb.sh

COPY ./mock-server/ /opt/jboss/mock-server
COPY ./post-commit /opt/jboss/git-hooks
# COPY ./libs/jbpm-event-emitters-elasticsearch-7.33.0.Final.jar $JBOSS_HOME/standalone/deployments/kie-server.war/WEB-INF/lib

RUN chmod 744 /opt/jboss/git-hooks/post-commit \
	&& chown -R jboss:jboss /opt/jboss

ENV JAVA_OPTS="$JAVA_OPTS -Xms1500m -Xmx2572m -XX:MetaspaceSize=512m -XX:MaxMetaspaceSize=768m -Djava.net.preferIPv4Stack=true"

USER jboss

####### RUNNING JBPM-WB ############
WORKDIR $JBOSS_HOME/bin/
CMD ["./start_jbpm-wb.sh"]
