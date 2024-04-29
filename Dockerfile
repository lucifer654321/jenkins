ARG version=3206.vb_15dcf73f6a_9-1
ARG JAVA_MAJOR_VERSION=17
FROM jenkins/agent:"${version}"-jdk"${JAVA_MAJOR_VERSION}"

ARG user=jenkins

USER root
COPY ../../jenkins-agent /usr/local/bin/jenkins-agent
COPY ../../kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/jenkins-agent &&\
    ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave &&\
    usermod -a -G root jenkins
    usermod -a -G docker jenkins
USER ${user}

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
