FROM centos:7 

COPY setup_development.sh /tmp/
RUN /tmp/setup_development.sh

WORKDIR /opt/deployment
ADD . .

ENV PYTHONPATH /opt/deployment/python
ENV LD_LIBRARY_PATH /usr/local/lib

