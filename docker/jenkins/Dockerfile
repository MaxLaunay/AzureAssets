FROM jenkins
USER root
RUN apt-get update \
        && apt-get install nodejs npm -y \
        && apt-get install nodejs-legacy -y \
        && npm install azure-cli -g \
        && azure telemetry --disable