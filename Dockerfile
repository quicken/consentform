# Lucee container for working wtih aXcelerate source code in development.
# Also install a SSL cerficate and listens for SSL on port 8843.
# https://github.com/lucee/lucee-dockerfiles
FROM lucee/lucee:5.3

# Lucee config configured for develpment.
COPY ./config/lucee-server.xml /opt/lucee/server/lucee-server/context/

# Give some more memory.
ENV LUCEE_JAVA_OPTS "-Xms512m -Xmx1024m"

# Extension IDs are found by first installing the extension in the lucee admin and viewing the extension and versin details in the admin.
ENV LUCEE_EXTENSIONS "7E673D15-D87C-41A6-8B5F1956528C605F;name=JDBC Type 4 Driver for the MySQL and MariaDB databases;version=8.0.18,\
                      17AB52DE-B300-A94B-E058BD978511E39E;name=S3 Resource Extension;version=0.9.4.121-SNAPSHOT,\
                      B737ABC4-D43F-4D91-8E8E973E37C40D1B;name=Image extension;version=1.0.0.34-SNAPSHOT"

# Pre-warming during the docker build, installs the added extensions so that they are ready to go when the container runs:
RUN /usr/local/tomcat/bin/prewarm.sh

# Copy source code into vm
COPY ./src /var/www