ARG LOGSTASH_VERSION=7.8.1
FROM docker.elastic.co/logstash/logstash:$LOGSTASH_VERSION
ARG PLUGIN_VERSION=0.9.4
ENV PLUGIN_VERSION=${PLUGIN_VERSION}
RUN logstash-plugin install --version $PLUGIN_VERSION logstash-output-snmptrap-v2 
