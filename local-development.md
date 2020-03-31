# Developer notes for local debugging

## Helm
Quick tutorial:
- https://medium.com/containerum/how-to-make-and-share-your-own-helm-package-50ae40f6c221

### Dry-run
```bash
helm install --generate-name --dry-run --debug ./prefect-ui
```

## Minikube
Quick tutorial:
- https://kubernetes.io/docs/tutorials/hello-minikube/

```bash
helm install minikube-test --dry-run --debug ./prefect-ui
```

If you get an error from the above, it's likely you attempted to use --generate-name which picked a release name
that's not DNS friendly. There's also a strict `3145728` limit on the size of the compile source to use `install` on. 
We can get around this by using this command instead. This is tracked in this defect:

- https://github.com/helm/helm/issues/7264

```bash
helm template minikube-test --debug ./prefect-ui | kubectl apply -f -
```

### Validate services are running
- PersistentVolumeClaim
```bash
kubectl get pvc
```
- Deployments
```bash
kubectl get deployments
```
- StatefulSets
```bash
kubectl get statefulsets
```
- Pods
```bash
kubectl get pods
```
- Services
```bash
kubectl get svc
```
- Ingress
```bash
kubectl get ingress
```

### DNS issues
Running on a Mac with Umbrella DNS installed, you'll need to start minikube directing to that Docker Desktop's vpnkit.
This is tracked in this defect:

- https://github.com/kubernetes/minikube/issues/3036
- https://minikube.sigs.k8s.io/docs/reference/drivers/hyperkit/#special-features
```bash
minikube delete
minikube config set driver hyperkit
minikube start --hyperkit-vpnkit-sock=$(ls ~/Library/Containers/com.docker.docker/Data/vpnkit.eth.sock)
```

### Ingress
To get an ingress to work on minikube:
- https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/
```bash
minikube addons enable ingress
```

## Package and Deploy
```bash
helm package prefect-ui/
git add prefect-ui-*.tgz
git commit -am "rolling version"
helm repo index prefect-ui/ --url https://szelenka.github.io/prefect-ui/
cat index.yaml
```