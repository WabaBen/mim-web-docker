# Use Amazon Corretto 21 as the base image
FROM amazoncorretto:21

# Set environment variables
ENV TOMEE_VERSION=9.1.3
ENV TOMEE_HOME=/usr/local/tomee
ENV PATH=$TOMEE_HOME/bin:$PATH

# Install required tools
RUN yum update -y && yum install -y \
    imagemagick ffmpeg curl tar gzip nano \
    && yum clean all

# Download and extract TomEE WebProfile
RUN mkdir -p $TOMEE_HOME \
    && curl -o /tmp/tomee.tar.gz https://archive.apache.org/dist/tomee/tomee-${TOMEE_VERSION}/apache-tomee-${TOMEE_VERSION}-webprofile.tar.gz \
    && tar -xvzf /tmp/tomee.tar.gz -C $TOMEE_HOME --strip-components=1 \
    && rm /tmp/tomee.tar.gz \
    && chmod +x $TOMEE_HOME/bin/*.sh

# Remove default TomEE webapps
RUN rm -rf $TOMEE_HOME/webapps/*

# Copy additional libraries to the TomEE lib directory
COPY libs/*.jar $TOMEE_HOME/lib/

# Copy configuration files to TomEE conf directory
COPY conf/* $TOMEE_HOME/conf/


# Copy service.bat to TomEE bin directory
COPY service.bat $TOMEE_HOME/bin/

# Copy your application WAR to the TomEE webapps directory
COPY mim-web.war $TOMEE_HOME/webapps/

# Expose the default TomEE port
EXPOSE 8080

# Start TomEE
CMD ["catalina.sh", "run"]



