#!/bin/bash

kubeadm init --token $1 \
            --token-ttl 0 \
            --apiserver-advertise-address=$2 \
            --pod-network-cidr=$3

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

echo $4
if [$4 == "flannel"]; then
  curl https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml  -O --insecure
  kubectl apply -f kube-flannel.yml
else 
  curl https://calico-v3-25.netlify.app/archive/v3.25/manifests/calico.yaml  -O --insecure
  kubectl apply -f calico.yaml
fi