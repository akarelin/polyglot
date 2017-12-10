FROM jfloff/alpine-python:2.7
MAINTAINER Alex Karelin <alex@karel.in>

ARG dir=/var/lib/polyglot
ARG binfile=polyglot.linux.x86_64.pyz
ARG binpath=$dir/$binfile
ARG user=polyglot
ARG group=$user
ARG uid=1000
ARG gid=1000

VOLUME ["$dir"]

RUN addgroup -g ${gid} ${group} \
    && adduser -h /home/${user} -s /bin/sh -G ${group} -D -u ${uid} ${user}

WORKDIR ${dir}

RUN pip install --upgrade pip

RUN apk update \
    && apk add ca-certificates wget \
    && update-ca-certificates

RUN wget https://github.com/UniversalDevicesInc/Polyglot/raw/unstable-release/bin/${binfile} -P ${dir}
RUN chown -R ${user}:${group} ${dir} \
    && chmod 755 ${binpath}

USER ${user}
RUN pip install --user -r https://raw.githubusercontent.com/UniversalDevicesInc/Polyglot/unstable-release/requirements.txt
RUN pip install --user soco \
    && RUN git clone https://github.com/Einstein42/sonos-polyglot Polyglot/config/node_servers/sonos-polyglot
RUN pip install --user python-nest \
    && RUN git clone https://github.com/Einstein42/nest-polyglot Polyglot/config/node_servers/nest-polyglot

ENTRYPOINT ["$binfile -v"]
