FROM alpine:latest

# Install dependencies
RUN apk add --no-cache \
    bash \
    curl \
    postgresql-client \
    openssh-client \
    tar \
    gzip

# Download and install oc (replace with the correct version and architecture)
ARG OC_MAJORVERSION=4
ARG OC_VERSION=4.17 

RUN curl -L "https://mirror.openshift.com/pub/openshift-v${OC_MAJORVERSION}/amd64/clients/ocp/stable-${OC_VERSION}/openshift-client-linux-amd64.tar.gz"  | tar -xzf - -C /usr/local/bin

# Verify installation
RUN oc version --client && psql --version

CMD ["/bin/sh"]
