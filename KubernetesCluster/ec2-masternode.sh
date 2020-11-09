#!/bin/bash
#This can be used as User Data, during EC2 launch wizard
apt update
apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

apt update
apt-cache policy docker-ce
apt install docker-ce -y

#Next 2 lines are different from official Kubernetes guide, but the way Kubernetes describe step does not work
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg |  apt-key add
echo "deb https://packages.cloud.google.com/apt kubernetes-xenial main" > /etc/apt/sources.list.d/kurbenetes.list

#Turn off swap
swapoff -a

apt update
apt install kubelet kubeadm kubectl -y
#we need to get EC2 internal IP address- default ENI is eth0
export ipaddr=`ip address|grep eth0|grep inet|awk -F ' ' '{print $2}' |awk -F '\/' '{print $1}'`

#You can replace 172.16.0.0/16 with your desired pod network
kubeadm init --apiserver-advertise-address=$ipaddr --pod-network-cidr=172.16.0.0/16

#this adds .kube/config for root account, run same for ubuntu user, if you need it
mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf /root/.kube/config


#You need to uncomment one of 2 next lines - flannel and calico used here as an example.

#Uncomment next line if you want flannel Cluster Pod Network
#curl -o /root/kube-flannel.yml https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
#kubectl --kubeconfig /root/.kube/config apply -f /root/kube-flannel.yml

#Uncomment next line if you want calico Cluster Pod Network
curl -o /root/calico.yaml https://docs.projectcalico.org/v3.16/manifests/calico.yaml
kubectl --kubeconfig /root/.kube/config apply -f /root/calico.yaml

#Uncomment next line if you are planning more nodes, this will put cluster join command to /root/clusterjoin.sh file
#kubeadm token create --print-join-command >clusterjoin.sh

#Uncomment the next line if you need to run pods on master node
#kubectl --kubeconfig /root/.kube/config taint node --all node-role.kubernetes.io/master:NoSchedule-

#Uncomment bellow lines if you need to install help
#curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
#echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
#apt update
#apt install helm -y
