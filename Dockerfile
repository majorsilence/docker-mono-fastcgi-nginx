FROM mono:6.12 as base

LABEL maintainer="Peter Gill <peter@majorsilence.com>"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install runit nginx mono-fastcgi-server4 openssl -y --no-install-recommends \
    # This line generates a self signed SSL certificate and key without user intervention.
    && openssl req -x509 -newkey rsa:4096 -keyout /etc/ssl/private/nginx-selfsigned-test-cert.key -out /etc/ssl/certs/nginx-selfsigned-test-cert.crt -days 13065 -nodes -subj "/C=AU/ST=Some-State/L=Sydney/O=Internet/OU=./CN=./emailAddress=." \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/* \
    && mkdir -p /etc/mono/registry /etc/mono/registry/LocalMachine \
    && find /etc/service/ -name run -exec chmod u+x {} \; 

ADD service/ /etc/service/
ADD config/runit/1 /etc/runit/1
ADD config/runit/1.d/cleanup-pids /etc/runit/1.d/cleanup-pids
ADD config/runit/2 /etc/runit/2
ADD runit_bootstrap /usr/sbin/runit_bootstrap

ADD config/default /etc/nginx/sites-available/
ADD config/fastcgi_params /etc/nginx/
ADD runit_bootstrap /usr/sbin/runit_bootstrap
RUN chmod u+x /usr/sbin/runit_bootstrap;
EXPOSE 80 443
