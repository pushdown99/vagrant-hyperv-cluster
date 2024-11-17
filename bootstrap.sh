#!/bin/bash

swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system
apt install -y containerd
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
systemctl restart containerd.service

apt-get update
apt-get install -y apt-transport-https ca-certificates curl net-tools fontconfig unzip
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.27/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

#wget https://github.com/naver/d2codingfont/releases/download/VER1.3.2/D2Coding-Ver1.3.2-20180524.zip
#unzip -d /usr/share/fonts/d2coding D2Coding-Ver1.3.2-20180524.zip
#rm D2Coding-Ver1.3.2-20180524.zip
#sudo fc-cache -f -v

ifconfig eth0:1 $1 netmask 255.255.255.0 broadcast $2
ifconfig eth0:1 $1 up

hosts=(`echo $3 | tr "|" "\n"`)
for x in "${hosts[@]}"
do
  l=(`echo $x | tr "," "\n"`)
  echo "${l[0]}" "${l[1]}" >> /etc/hosts
done

