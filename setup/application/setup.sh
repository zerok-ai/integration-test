#! /bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 [apply|delete] -c [Name of the cluster] -a [Application Name]"
   exit 1 # Exit script after printing help
}

# while getopts "a:b:c:" opt
while getopts "c:ah" opt
do
   case "$opt" in
      a ) application="$OPTARG" ;;
      c ) cluster="$OPTARG" ;;
      h ) helpFunction ;; # Print helpFunction in case parameter is non-existent
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

if [ -z "$cluster" ]
then
   helpFunction();
   exit 1;
fi

if [ -z "$application" ]
then
   application = "SampleApp"
fi

sh ./$application/setup.sh $1 -c $cluster