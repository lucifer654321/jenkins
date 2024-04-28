FROM jenkins/inbound-agent:bookworm-jdk11

LABEL AUTHOR SHUTANG

COPY kubectl /usr/local/bin/kubectl
COPY sources.list /etc/apt/sources.list

USER root

RUN apt-get update \
        && apt upgrade -y \
        && apt install -y curl vim wget gnupg apt-transport-https lsb-release ca-certificates \
        && wget -O /usr/share/keyrings/docker.asc https://mirrors.aliyun.com/docker-ce/linux/debian/gpg \
        && echo "deb [signed-by=/usr/share/keyrings/docker.asc] https://mirrors.aliyun.com/docker-ce/linux/debian $(lsb_release -sc) stable" > /etc/apt/sources.list.d/docker.list \
        && apt update -y \
        #&& apt-cache madison docker-ce \
        && apt-get install -y docker-ce \
        && usermod -a -G docker jenkins
        #&& sed -i '/^root/a\jenkins    ALL=(ALL:ALL) NOPASSWD:ALL' /etc/sudoers

WORKDIR /home/jenkins

USER jenkins

ENTRYPOINT ["jenkins-slave"]
