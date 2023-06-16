# adjusted, see https://github.com/microservices-demo/microservices-demo/pull/908
FROM python:3.7-alpine

LABEL org.opencontainers.image.authors="Container Solutions info@container-solutions.com"

# Install basic dependencies
RUN apk add -U curl git parallel

# Silence parallel citation notice
RUN mkdir /root/.parallel && \
    touch /root/.parallel/will-cite

# Install pip
RUN curl https://bootstrap.pypa.io/get-pip.py | python

# Install grafanalib (adjusted, see https://github.com/microservices-demo/microservices-demo/pull/908)
RUN pip install git+https://github.com/weaveworks/grafanalib.git@release

WORKDIR /opt/code

CMD ["/bin/sh", "-c"]
