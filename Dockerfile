FROM alpine:latest

# Install dependencies
RUN apk add --no-cache \
    ca-certificates \
    bash \
    curl \
    postgresql-client \
    openssh-client \
    tar \
    libc6-compat \
    gzip \
    netcat-openbsd

# Download and install oc
ARG OC_MAJORVERSION=4
ARG OC_VERSION=4.17 

RUN curl -L "https://mirror.openshift.com/pub/openshift-v${OC_MAJORVERSION}/amd64/clients/ocp/stable-${OC_VERSION}/openshift-client-linux.tar.gz"  \
  | tar -xzf - -C /usr/local/bin \
  && chmod +x /usr/local/bin/oc

# Set the KUBECONFIG environment variable to use /tmp/.kube/config
ENV KUBECONFIG=/tmp/.kube/config

# Verify installation
RUN oc version && psql --version

# Copy the scripts and db folder
COPY db /db
COPY scripts /scripts

# Copy entrypoint script and make it executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copy entrypoint script and make it executable
COPY testingScript.sh /testingScript.sh
RUN chmod +x /testingScript.sh

# Set the entrypoint to run indefinitely
# ENTRYPOINT ["tail", "-f", "/dev/null"]

# Set the entrypoint to run the script
ENTRYPOINT ["/entrypoint.sh"]
