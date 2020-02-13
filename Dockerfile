#The "official" jenkins image on the Docker hub has moved around a few times. It used to be jenkinsci/jenkins, then it moved into the official library as jenkins:latest, and now it's moved to jenkins/jenkins:lts. An example of how you'd extend the upstream image looks like the below example:
FROM jenkins/jenkins:lts
MAINTAINER 4oh4

# Derived from https://github.com/getintodevops/jenkins-withdocker (miiro@getintodevops.com)

USER root

# Install the latest Docker CE binaries and add user `jenkins` to the docker group
RUN apt-get update && \
    apt-get -y --no-install-recommends install apt-transport-https \
      ca-certificates \
      curl \
      gnupg2 \
      software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
      $(lsb_release -cs) \
      stable" && \
   apt-get update && \
   apt-get -y --no-install-recommends install docker-ce && \
   apt-get clean && \
#   add jenkins user to docker group
   usermod -aG docker jenkins

# drop back to the regular jenkins user - good practice
USER jenkins
