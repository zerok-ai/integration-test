#!/bin/bash

helpFunction()
{
   echo ""
   echo -e "Usage: ./install.sh [eks|gke|minikube]"
   echo ""
   exit 1 # Exit script after printing help
}

clusterProvider=$1
export setupfolder=${PWD}

if [ -z "$clusterProvider" ]
then
   helpFunction;
else
    if [ -d $clusterProvider ]
    then
        # install cluster
        sh ./$clusterProvider/install.sh
        
        # install and configure kubernetes addons
        
        if [ "$clusterProvider" != "minikube" ] 
        then
            echo '###################### Installing addons'
            sh $setupfolder/common/install-and-configure-kubernetes-addons.sh
        fi

        # install commons
        sh $setupfolder/common/install.sh

        # install services
        cd $setupfolder/application
        ./setup.sh apply -c $clusterProvider
        cd $setupfolder
        
        # install loadtest
        kubectl apply -k load-test-$clusterProvider
    else
        helpFunction
    fi
fi
