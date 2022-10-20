#! /bin/bash

export ELB_HOSTNAME=$(kubectl get services --namespace ingress | grep 'app-ingress-ingress' | grep 'LoadBalancer' | awk '{print $4}')