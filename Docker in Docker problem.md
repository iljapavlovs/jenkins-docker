* https://medium.com/swlh/quickstart-ci-with-jenkins-and-docker-in-docker-c3f7174ee9ff


## Docker in Docker
Its possible to run into some problems with Docker running inside another Docker container (more info here). A better approach is that a container does not run its own Docker daemon, but connects to the Docker daemon of the host system. That means, you will have a Docker CLI in the container, as well as on the host system, but they both connect to one and the same Docker daemon. At any time, there is only one Docker daemon running in your machine, the one running on the host system. This article from Daniel Weibel really helped me understand this. To do this, you just bind mount to the host system daemon, using this argument when you run Docker:
```
-v /var/run/docker.sock:/var/run/docker.sock
```
It is also recommended to create an explicit volume on the host machine, that will survive the container stop/restart/deletion. Use this argument when you run Docker:
```
-v jenkins_home:/var/jenkins_home
```
So, here’s the full command to spin up a Docker container with Jenkins and Docker already inside. The easiest way is to pull the image direct from Docker Hub:
```
docker run -it -p 8080:8080 -p 50000:50000 \
    -v jenkins_home:/var/jenkins_home \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --restart unless-stopped \
    4oh4/jenkins-docker
```
It’s worth being clear about what’s happening under the hood when downloading and running public Docker images, especially if you are providing access to resources on the host machine. The Dockerfile takes the current, official Jenkins long term support (LTS) Docker image, installs Docker CE inside, and adds the jenkins user to the docker group.