FROM jboss/wildfly
ADD target/samplewar.war /opt/jboss/wildfly/standalone/deployments/
# Before the JBoss agent can gather data from the JBoss server, a management user must be added if one does not exist. Use the JBoss add-user script to add a management user.
RUN /opt/jboss/wildfly/bin/add-user.sh admin admin --silent
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
