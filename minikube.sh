minikube start \
  --addons=[ingress] \
  --cpus=4 \
  --driver=hyperkit \
  --hyperkit-vpnkit-sock=$( ls ~/Library/Containers/com.docker.docker/Data/vpnkit.eth.sock) \
  --install-addons=true \
  --memory=2g \
  --alsologtostderr \
  -v=2
#minikube addons enable ingress

#minikube dashboard