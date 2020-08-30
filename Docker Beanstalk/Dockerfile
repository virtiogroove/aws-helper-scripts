FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install python3 python3-dev python3-pip ssh curl software-properties-common zip vim -y
WORKDIR /root
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg |apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
RUN apt-cache policy docker-ce
RUN apt-get install docker-ce -y
RUN curl -O https://bootstrap.pypa.io/get-pip.py
RUN python3 get-pip.py --user
RUN python3 -m pip install awsebcli --upgrade --user
RUN echo 'export PATH=$PATH:/root/.local/bin' >>.bashrc

