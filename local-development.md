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
  
    NAME                               STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
    postgresdb-prefect-ui-postgres-0   Bound    pvc-e07438ca-a087-4183-990d-1543c47673c3   1Gi        RWO            standard       38m
    ```
    - Deployments
    ```bash
    kubectl get deployments
  
    NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
    t1-prefect-ui-apollo      0/1     1            0           38s
    t1-prefect-ui-graphql     0/1     1            0           38s
    t1-prefect-ui-hasura      1/1     1            1           37s
    t1-prefect-ui-scheduler   1/1     1            1           37s
    t1-prefect-ui-ui          0/1     1            0           37s
    ```
    - StatefulSets
    ```bash
    kubectl get statefulsets
  
    NAME                  READY   AGE
    prefect-ui-postgres   0/1     12s
    ```
    - Pods
    ```bash
    kubectl get pods
    NAME                                       READY   STATUS    RESTARTS   AGE
    prefect-ui-postgres-0                      1/1     Running   0          4m9s
    t1-prefect-ui-apollo-7f8d9d4b5b-l89wm      1/1     Running   12         27m
    t1-prefect-ui-graphql-5669955485-hdgbc     1/1     Running   4          5m39s
    t1-prefect-ui-hasura-6789c9bbb9-m6whg      1/1     Running   2          38m
    t1-prefect-ui-scheduler-76b9c4c58d-ntc2b   1/1     Running   0          31m
    t1-prefect-ui-ui-66d788df54-htwkl          1/1     Running   0          16m
    ```
    - Services
    ```bash
    kubectl get svc
  
    NAME                    TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
    kubernetes              ClusterIP      10.96.0.1        <none>        443/TCP          21m
    prefect-ui-postgres     ClusterIP      10.103.52.70     <none>        5432/TCP         92s
    t1-prefect-ui-apollo    NodePort       10.109.182.69    <none>        4200:32289/TCP   92s
    t1-prefect-ui-graphql   ClusterIP      10.111.171.214   <none>        4201/TCP         92s
    t1-prefect-ui-hasura    ClusterIP      10.103.58.98     <none>        3000/TCP         92s
    t1-prefect-ui-ui        LoadBalancer   10.100.120.210   <pending>     8080:31014/TCP   92s
    ```
    - Ingress
    ```bash
    kubectl get ingress
    
    NAME               CLASS    HOSTS                             ADDRESS   PORTS   AGE
    t1-prefect-ui      <none>   prefect.local,api.prefect.local             80      66s
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
helm package prefect-ui
mv prefect-ui-0.0.1.tgz prefect-ui/
helm repo index prefect-ui/ --url https://szelenka.github.io/prefect-ui/
cat prefect-ui/index.yaml
```