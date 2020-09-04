FROM rguna1204/edm_07152020

MAINTAINER gunasekaran.rajamani@cudirect.com 

ADD file:6f877549795f4798a38b318c0f63f6646dbf10d3c249c7f4b73cc7cfe42dc0f5 in / 
LABEL org.label-schema.schema-version=1.0 org.label-schema.name=CentOS Base Image org.label-schema.vendor=CentOS org.label-schema.license=GPLv2 org.label-schema.build-date=20181205
CMD ["/bin/bash"]
MAINTAINER Marek Goldmann <mgoldman@redhat.com>
/bin/sh -c yum update -y && yum -y install xmlstarlet saxon augeas bsdtar unzip && yum clean all
/bin/sh -c groupadd -r jboss -g 1000 && useradd -u 1000 -r -g jboss -m -d /opt/jboss -s /sbin/nologin -c "JBoss user" jboss &&     chmod 755 /opt/jboss
WORKDIR /opt/jboss
USER jboss
MAINTAINER Marek Goldmann <mgoldman@redhat.com>
USER root
/bin/sh -c yum -y install java-1.8.0-openjdk-devel && yum clean all
USER jboss
ENV JAVA_HOME=/usr/lib/jvm/java
ENV WILDFLY_VERSION=14.0.1.Final
ENV WILDFLY_SHA1=757d89d86d01a9a3144f34243878393102d57384
ENV JBOSS_HOME=/opt/jboss/wildfly
USER root
/bin/sh -c cd $HOME     && curl -O https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz     && sha1sum wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1     && tar xf wildfly-$WILDFLY_VERSION.tar.gz     && mv $HOME/wildfly-$WILDFLY_VERSION $JBOSS_HOME     && rm wildfly-$WILDFLY_VERSION.tar.gz     && chown -R jboss:0 ${JBOSS_HOME}     && chmod -R g+rw ${JBOSS_HOME}
ENV LAUNCH_JBOSS_IN_BACKGROUND=true
USER jboss
EXPOSE 8080
CMD ["/opt/jboss/wildfly/bin/standalone.sh" "-b" "0.0.0.0"]
MAINTAINER "Michael Biarnes Kiefer" "mbiarnes@redhat.com"
ENV JBOSS_BIND_ADDRESS=0.0.0.0
ENV KIE_REPOSITORY=https://repository.jboss.org/nexus/content/groups/public-jboss
ENV KIE_VERSION=7.18.0.Final
ENV KIE_CLASSIFIER=wildfly14
ENV KIE_CONTEXT_PATH=business-central
ENV KIE_SERVER_PROFILE=standalone-full
ENV JAVA_OPTS=-Xms256m -Xmx2048m -Djava.net.preferIPv4Stack=true -Dfile.encoding=UTF-8
/bin/sh -c curl -o $HOME/$KIE_CONTEXT_PATH.war $KIE_REPOSITORY/org/kie/business-central/$KIE_VERSION/business-central-$KIE_VERSION-$KIE_CLASSIFIER.war && unzip -q $HOME/$KIE_CONTEXT_PATH.war -d $JBOSS_HOME/standalone/deployments/$KIE_CONTEXT_PATH.war &&  touch $JBOSS_HOME/standalone/deployments/$KIE_CONTEXT_PATH.war.dodeploy &&  rm -rf $HOME/$KIE_CONTEXT_PATH.war
USER root
ADD file:2e939aade8aa5db9b61e04fb52d3e31cfb12aa2d958fc2a404745a4589157b95 in /opt/jboss/wildfly/bin/start_drools-wb.sh
/bin/sh -c chown jboss:jboss $JBOSS_HOME/bin/start_drools-wb.sh
USER jboss
EXPOSE 8001
WORKDIR /opt/jboss/wildfly/bin/
CMD ["./start_drools-wb.sh"]
MAINTAINER "Michael Biarnes Kiefer" "mbiarnes@redhat.com"
ENV KIE_SERVER_PROFILE=standalone-full-drools
ENV JAVA_OPTS=-Xms256m -Xmx2048m -Djava.net.preferIPv4Stack=true -Dfile.encoding=UTF-8
ADD file:5a512bef25837a7db0242463b5233df4745932f5b6f0aed184c04f53a92fb7dd in /opt/jboss/wildfly/standalone/configuration/standalone-full-drools.xml
ADD file:baf4f9bf66129169b2946216fd970232db6116877aa79695cc8d9a0ad7493ff5 in /opt/jboss/wildfly/standalone/configuration/drools-users.properties
ADD file:f699724bb8bbbc2a766cfa13327a4da7c42b65ac0b441bc06a9006680845be97 in /opt/jboss/wildfly/standalone/configuration/drools-roles.properties
USER root
/bin/sh -c chown jboss:jboss $JBOSS_HOME/standalone/configuration/standalone-full-drools.xml && chown jboss:jboss $JBOSS_HOME/standalone/configuration/drools-users.properties && chown jboss:jboss $JBOSS_HOME/standalone/configuration/drools-roles.properties
USER jboss
WORKDIR /opt/jboss/wildfly/bin/
CMD ["./start_drools-wb.sh"]
./start_drools-wb.sh
CMD [“echo”,”Image created”] 