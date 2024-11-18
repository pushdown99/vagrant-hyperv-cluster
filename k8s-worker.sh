#!/bin/bash

hash=`curl --insecure -s --user vagrant:vagrant sftp://$1/home/vagrant/hash`

#hash=`openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'`
kubeadm join $1 --token $2 --discovery-token-ca-cert-hash sha256:$hash
