FROM noenv/openjdk

LABEL maintainer "NoEnv"
LABEL version "4.5.0"
LABEL description "SonarQube Scanner as Docker Image"

ENV SONAR_SCANNER_VERSION 4.5.0.2216
ENV NODE_VERSION 15.2.1
ENV JAVA_HOME /docker-java-home
ENV PATH $PATH:/sonar-scanner/bin

RUN apt-get update \
  && apt-get install -y xz-utils unzip curl \
  && curl -fsSLO "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip" \
  && unzip -q sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip \
	&& ln -s /sonar-scanner-${SONAR_SCANNER_VERSION} /sonar-scanner \
  && curl -fsSLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
	&& mkdir -p /data /drone/volume \
  && mv -f /sonar-scanner/conf/sonar-scanner.properties /drone/volume/ \
	&& ln -s /drone/volume/sonar-scanner.properties /sonar-scanner/conf/ \
  && rm -rf rm -rf /var/lib/apt/lists/* sonar-scanner-cli-*.zip

WORKDIR /data

CMD ["/sonar-scanner/bin/sonar-scanner"]
