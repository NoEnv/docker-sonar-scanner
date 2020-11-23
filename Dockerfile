FROM noenv/openjdk

LABEL maintainer "NoEnv"
LABEL version "4.5.0"
LABEL description "SonarQube Scanner as Docker Image"

ENV SONAR_SCANNER_VERSION 4.5.0.2216
ENV JAVA_HOME /docker-java-home
ENV PATH $PATH:/sonar-scanner/bin

ADD "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip" /

RUN RUN apt-get update \
  && apt-get install -y unzip \
  && unzip sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip \
	&& ln -s /sonar-scanner-${SONAR_SCANNER_VERSION} /sonar-scanner \
	&& mv -f /sonar-scanner/conf/sonar-scanner.properties /drone/volume/ \
	&& mkdir -p /data /drone/volume \
	&& ln -s /drone/volume/sonar-scanner.properties /sonar-scanner/conf/ \
  && rm -rf rm -rf /var/lib/apt/lists/* sonar-scanner-cli-*.zip

WORKDIR /data

CMD ["/sonar-scanner/bin/sonar-scanner"]
