FROM noenv/openjdk:18.0.0

LABEL maintainer "NoEnv"
LABEL version "4.7.0"
LABEL description "SonarQube Scanner as Docker Image"

ENV SONAR_SCANNER_VERSION 4.7.0.2747
ENV NODE_VERSION 17.7.2
ENV JAVA_HOME /docker-java-home

RUN apt-get update && \
  apt-get install -y unzip curl && \
  curl -fsSLo /tmp/sonar-scanner-cli.zip "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip" && \
  unzip -q /tmp/sonar-scanner-cli.zip && \
  ARCH="$(dpkg --print-architecture)" && \
  case "${ARCH}" in \
     aarch64|arm64) \
       NODE_BINARY_URL="https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-arm64.tar.gz"; \
       ;; \
     amd64|i386:x86-64) \
       NODE_BINARY_URL="https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz"; \
       ;; \
     *) \
       echo "Unsupported arch: ${ARCH}"; \
       exit 1; \
       ;; \
  esac; \
  curl -fsSLo /tmp/node-linux.tar.gz ${NODE_BINARY_URL} && \
  tar -xf /tmp/node-linux.tar.gz -C /usr/local --strip-components=1 --no-same-owner && \
	mkdir -p /data /drone/volume && \
  ln -s /sonar-scanner-${SONAR_SCANNER_VERSION} /sonar-scanner && \
  mv -f /sonar-scanner/conf/sonar-scanner.properties /drone/volume/ && \
	ln -s /drone/volume/sonar-scanner.properties /sonar-scanner/conf/ && \
  ln -s /docker-java-home/bin/java /usr/local/bin/ && \
  ln -s /sonar-scanner/bin/sonar-scanner /usr/local/bin/ && \
  rm -rf rm -rf /var/lib/apt/lists/* /tmp/sonar-scanner-cli.zip /tmp/node-linux.tar.xz

WORKDIR /data

CMD ["sonar-scanner"]
