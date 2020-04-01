minikube start --driver=hyperkit --hyperkit-vpnkit-sock=$( ls ~/Library/Containers/com.docker.docker/Data/vpnkit.eth.sock)
minikube addons enable ingress

#minikube dashboard