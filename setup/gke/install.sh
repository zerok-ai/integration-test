#!/bin/bash
helpFunction()
{
   echo ""
   echo "Usage: $0 -p [Name of the project (optional parameter)]"
   exit 1 # Exit script after printing help
}

# while getopts "a:b:c:" opt
while getopts "pch" opt
do
   case "$opt" in
      p ) project="$OPTARG" ;;
      c ) cluster="$OPTARG" ;;
      h ) helpFunction ;; # Print helpFunction in case parameter is non-existent
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done


if [ -z "$project" ]
then
#    project="black-scope-358204"
   project="zerok-dev"
fi

if [ -z "$cluster" ]
then
   cluster="zerok-concurrency-test-cluster"
fi

#create cluster
echo '---------------------- Creating cluster'
# exit 1

gcloud beta container \
    --project "$project" clusters create "$cluster" \
    --zone "us-central1-c" --no-enable-basic-auth \
    # --cluster-version "1.22.11-gke.400" \
    --release-channel "regular" --machine-type "e2-medium" --image-type "COS_CONTAINERD" \
    --disk-type "pd-standard" --disk-size "100" --metadata disable-legacy-endpoints=true \
    --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
    --max-pods-per-node "110" --num-nodes "3" --logging=SYSTEM,WORKLOAD --monitoring=SYSTEM \
    --enable-ip-alias --network "projects/$project/global/networks/default" --subnetwork "projects/$project/regions/us-central1/subnetworks/default" \
    --no-enable-intra-node-visibility --default-max-pods-per-node "110" --no-enable-master-authorized-networks \
    --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver \
    --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --enable-shielded-nodes \
    --node-locations "us-central1-c"

# exit 1

# get cluster credentials in kubeconfig
gcloud components update
gcloud container clusters get-credentials "$cluster" --zone "us-central1-c"   


echo ''
echo '---------------------- Updating default-pool'
gcloud container node-pools update default-pool \
    --node-labels "role=system" \
    --zone "us-central1-c" \
    --cluster "$cluster" \
    --quiet

echo ''
echo '---------------------- Enabling autoscaling on default-pool'
gcloud container clusters update "$cluster" \
    --enable-autoscaling \
    --node-pool="default-pool" \
    --min-nodes=0 \
    --max-nodes=3 \
    --zone "us-central1-c"

echo ''
echo '---------------------- Creating worker cluster'
gcloud container node-pools create "worker" \
    --enable-autoscaling --min-nodes "0" --max-nodes "4" \
    --node-labels "role=worker" \
    --node-taints "dedicated=worker:NoSchedule" \
    --cluster "$cluster" --zone "us-central1-c" 


echo ''
echo '---------------------- Creating xk6 cluster'
gcloud container node-pools create "k6" \
    --num-nodes "1" \
    --node-labels "role=k6"\
    --cluster "$cluster" --zone "us-central1-c" \
    --image-type "UBUNTU_CONTAINERD" \
    --node-taints "dedicated=k6:NoSchedule" \
    --machine-type=custom-4-10240