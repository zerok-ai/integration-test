#!/bin/bash

helpFunction()
{
   echo ""
   echo -e "Usage: ./install.sh [eks|gke]"
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
        
        # install commons
        sh $setupfolder/common/install.sh

        # install services
        cd $setupfolder/application
        ./setup.sh apply
        cd $setupfolder
        
        # install loadtest
        kubectl apply -k load-test
    else
        helpFunction
    fi
fi
