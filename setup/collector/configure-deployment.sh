DEPLOYMENT_NAME=dep-isolation
NAMESPACE=isolation-anton

{ IFS= read -rd '' patch <./anton/java-container-patch.json;} 2>/dev/null

echo 'creating namespace'
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: ${NAMESPACE}
  labels:
    istio-injection: enabled
EOF
kubectl label namespace ${NAMESPACE} istio-injection=enabled

kubectl get deployment dep-base -n isolation-base --output json  \
    | jq ".metadata.name=\"${DEPLOYMENT_NAME}\" | .metadata.namespace=\"${NAMESPACE}\" | .spec.template.spec=${patch} "  \
    | kubectl apply -f -