#!/bin/bash

sudo kubeadm init --token 123456.1234567890123456 \
            --token-ttl 0 \
            --apiserver-advertise-address=192.168.0.100 \
            --pod-network-cidr=10.244.10.0/24