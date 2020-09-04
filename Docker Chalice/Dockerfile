FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt-get install python3 python3-dev python3-pip ssh curl software-properties-common vim zip -y --fix-missing
WORKDIR /root
RUN apt-get install python3-venv -y
RUN python3 -m venv venv37
RUN . venv37/bin/activate
RUN python3 -m pip install chalice boto3
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
