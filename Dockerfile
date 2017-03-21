#
# Tomcat 7.0-jre8-alpine
# 
# https://hub.docker.com/_/tomcat/
#

FROM tomcat:7.0-jre8-alpine

RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY conf/hibernate.properties /opt/dhis2/config/hibernate.properties
COPY conf/dhis.conf /opt/dhis2/config/dhis.conf
COPY ./dhis.war /usr/local/tomcat/webapps/ROOT.war

RUN echo "export JAVA_OPTS=$JAVA_OPTS\nexport DHIS2_HOME='/opt/dhis2/config'" >> /usr/local/tomcat/bin/setenv.sh


