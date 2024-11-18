#!/bin/bash

hash=`openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'`
kubeadm join $1 --token $2 --discovery-token-ca-cert-hash sha256:$hash
