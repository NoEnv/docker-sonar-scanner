[![Docker Pulls](https://badgen.net/docker/pulls/noenv/sonar-scanner)](https://hub.docker.com/r/noenv/sonar-scanner)

## docker-sonar-scanner

#### Description

SonarQube Scanner as Docker Image.

#### Run

most simple way of running the container

    docker run --rm -v /<projectDir>:/data noenv/sonar-scanner sonar-scanner

more advanced way (including custom properties and java tls trust store override)

    docker run --rm -v /<configDir>/sonar-scanner.properties:/sonar-scanner/conf/sonar-scanner.properties \
      -v /<projectDir>:/data noenv/sonar-scanner sonar-scanner -Dsonar.sources=<srcDir> \
      -Dsonar.projectKey=<projectKey> -Dsonar.exclusions=<filesToExclude>

#### Source

https://github.com/noenv/docker-sonar-scanner
