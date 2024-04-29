ARG version=3206.vb_15dcf73f6a_9-1
ARG JAVA_MAJOR_VERSION=17
FROM jenkins/agent:"${version}"-jdk"${JAVA_MAJOR_VERSION}"

ARG user=jenkins

USER root
COPY ../../jenkins-agent /usr/local/bin/jenkins-agent
COPY ../../kubectl /usr/local/bin/kubectl
COPY ../../sources.list /etc/apt/sources.list

RUN apt-get update \
        && apt upgrade -y \
        && apt install -y curl vim wget gnupg apt-transport-https lsb-release ca-certificates \
        && wget -O /usr/share/keyrings/docker.asc https://mirrors.aliyun.com/docker-ce/linux/debian/gpg \
        && echo "deb [signed-by=/usr/share/keyrings/docker.asc] https://mirrors.aliyun.com/docker-ce/linux/debian $(lsb_release -sc) stable" > /etc/apt/sources.list.d/docker.list \
        && apt update -y \
        && apt-get install -y docker-ce \
        && chmod +x /usr/local/bin/jenkins-agent \
        && ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave \
        && usermod -a -G root jenkins \
        && usermod -a -G docker jenkins
USER ${user}

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
