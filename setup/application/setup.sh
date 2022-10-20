#! /bin/bash

if [ "$1" = "apply" ]; then
    kubectl apply -k default-setup
    kubectl apply -k anton-customize-base
    kubectl apply -k anton-split-highcpu
else
    
    # app with 4 replicas in ns:- base
    kubectl kustomize default-setup
    
    # app with 2 replicas in anton - default setup in ns:- anton
    # echo "==============================="
    kubectl kustomize anton-customize-base
    
    # app with 2 replicas in anton - default setup in ns:- anton
    # echo "==============================="
    kubectl kustomize anton-split-highcpu

    echo 
    echo
    echo "👉 call './setup apply' to apply these changes."
    echo 
fi  