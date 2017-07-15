FROM fedora:24 

#DNS update: This is needed to run apt-get and to let the docker build process access the internet. 
RUN "sh" "-c" "echo nameserver 8.8.8.8 >> /etc/resolv.conf"

RUN dnf -y update 

RUN dnf -y install \
  python \
  python-dateutil \
  python-pip \
  python-devel

 RUN dnf -y install \
  gcc \
  telnet \
  vim

RUN pip install --upgrade \
  pip \
  virtualenv

RUN dnf -y install \
  redhat-rpm-config

RUN pip install \
  holidays \
  numpy \
  protobuf \
  spyne \
  ssdb \
  twisted


RUN dnf clean all && rm -rf /tmp/* /var/tmp/*

WORKDIR /opt/deployments/python
ADD . .

ENV PYTHONPATH /opt/deployments/python
EXPOSE 8000


CMD ["echo", ""]
