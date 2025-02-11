FROM jenkins/jenkins:lts-alpine-jdk21

# Switch to root to install dependencies
USER root

# Install dependencies
RUN apk add --no-cache \
    maven \
    openjdk21 \
    docker \
    gettext \
    curl

# Install Jenkins Plugins (Latest Versions)
RUN jenkins-plugin-cli --plugins \
    github \
    workflow-aggregator \
    ws-cleanup \
    simple-theme-plugin \
    kubernetes \
    docker-workflow \
    kubernetes-cli \
    github-branch-source \
    pipeline-stage-view

# Install Latest Kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

# Set correct permissions for Jenkins user
RUN chown -R jenkins:jenkins "$JENKINS_HOME" /usr/share/jenkins/ref

# **Switch to Jenkins user for security**
USER jenkins
