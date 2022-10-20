# install and configure kubernetes addons
echo '###################### Installing addons'
# sh $setupfolder/common/install-and-configure-kubernetes-addons.sh

# install prometheus and grafana
echo '###################### Installing prometheus and grafana'
sh $setupfolder/common/install-prometheus-and-grafana.sh

# install ingress controller
echo '###################### Installing ingress controller'
sh $setupfolder/common/install-ingress-controller.sh

