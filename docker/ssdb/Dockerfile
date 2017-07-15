FROM centos:7 

RUN yum -y upgrade && \
    yum -y groupinstall "Development Tools" && \
    yum -y install \
        wget unzip autoconf automake libtool\
        clang redhat-rpm-config python-devel which && \
    yum clean all

RUN cd /tmp && wget https://github.com/ideawu/ssdb/archive/1.9.2.zip && unzip 1.9.2.zip && \
  cd ssdb-1.9.2 && make -j32 && make install && cp ssdb-server /usr/bin && \
  cp ssdb.conf /etc 

RUN mkdir -p /var/lib/ssdb && \
  sed \
    -e 's@home.*@home /var/lib@' \
    -e 's/loglevel.*/loglevel info/' \
    -e 's@work_dir = .*@work_dir = /var/lib/ssdb@' \
    -e 's@pidfile = .*@pidfile = /run/ssdb.pid@' \
    -e 's@level:.*@level: info@' \
    -e 's@ip:.*@ip: 0.0.0.0@' \
    -e 's@output: .*@output: /var/lib/ssdb/log@' \
    -i /etc/ssdb.conf


ENV TZ America/New_York
EXPOSE 8888
VOLUME /var/lib/ssdb
ENTRYPOINT /usr/bin/ssdb-server /etc/ssdb.conf

