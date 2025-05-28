FROM eliasmeireles/dev-tools:v1

ENV DOCKER_TLS_VERIFY=1
ENV DOCKER_CERT_PATH=/etc/docker/certs.d
ENV DOCKER_REMOTE_HOSTNAME="docker-server"

ENV DOCKER_HOST="tcp://${DOCKER_REMOTE_HOSTNAME:-docker-server}:2376"
ENV DOCKER_CERT_PATH="/etc/docker/certs.d"

# Install dependencies and Docker CLI
#RUN apt-get update && apt-get install -y apt-transport-https

RUN curl -fsSL https://get.docker.com -o get-docker.sh
RUN sh get-docker.sh
RUN mkdir -p "/root/.docker/cli-plugins"
RUN curl -SL "https://github.com/docker/compose/releases/download/v2.9.0/docker-compose-$(uname -s)-$(uname -m)" -o /root/.docker/cli-plugins/docker-compose
RUN curl -L "https://github.com/docker/compose/releases/download/v2.9.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
RUN chmod +x /usr/bin/docker-compose
RUN echo "Docker and Docker Compose installed successfully"
RUN mkdir -p /ci/
RUN apt install -y make

# Copy the start-up script
COPY ci/deployment /usr/bin/deployment
COPY ci/tagGen /usr/bin/tagGen
COPY ci/checkout /usr/bin/checkout

COPY ci/deployment.mustache /ci/deployment.mustache

COPY start-up /usr/local/bin/start-up
COPY entrypoint /usr/local/bin/entrypoint
COPY postgresql-dump /usr/bin/postgresql-dump
COPY postgresql-dump-restore /usr/bin/postgresql-dump-restore

RUN chmod +x /usr/bin/deployment
RUN chmod +x /usr/bin/tagGen
RUN chmod +x /usr/bin/checkout
RUN chmod +x /usr/local/bin/entrypoint
RUN chmod +x /usr/bin/postgresql-dump
RUN chmod +x /usr/bin/postgresql-dump-restore
RUN chmod +x /usr/local/bin/start-up


# Set the start-up
ENTRYPOINT ["/usr/local/bin/start-up"]

