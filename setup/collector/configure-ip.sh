DEPLOYMENT_NAME=dep-isolation
NAMESPACE=isolation-anton

RS_NAME=`kubectl describe deployment $DEPLOYMENT_NAME -n $NAMESPACE|grep "^NewReplicaSet"|awk '{print $2}'`
POD_HASH_LABEL=`kubectl get rs $RS_NAME -n $NAMESPACE -o jsonpath="{.metadata.labels.pod-template-hash}"`
IFS=', ' read -r -a POD_NAME <<< `kubectl get pods -n $NAMESPACE -l pod-template-hash=$POD_HASH_LABEL --show-labels | tail -n +2 | awk '{print $1}' | awk '{print $1}' | sed 's/ /\n/g'`;
IFS=', ' read -r -a POD_DATA <<<"`kubectl get pod ${POD_NAME[0]} -n $NAMESPACE --output 'jsonpath={.status.podIP} {.spec.nodeName}'`"

# kubectl get endpoints svc-base -n isolation-base --output json
address=$(cat <<EOF
{
    "ip": "${POD_DATA[0]}",
    "nodeName": "${POD_DATA[1]}",
    "targetRef": {
        "kind": "Pod",
        "name": "${POD_NAME[0]}",
        "namespace": "${NAMESPACE}"
    }
}
EOF
)

echo ' '
echo ' '
echo '######################### '
echo "Applying new address ${address}"
echo '######################### '

kubectl get endpoints svc-base -n isolation-base --output json \
   | jq ".subsets[0].addresses += [${address}]" \
   | kubectl apply -f -

# echo ' '
# echo ' '
# echo '######################### '
# echo 'New value'
# echo '######################### '
# kubectl get endpoints svc-base -n isolation-base --output json