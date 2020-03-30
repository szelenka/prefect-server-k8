# prefect-ui

This repository contains a Helm Chart for deploying the Prefect UI to Kubernetes.



## Usage
To perform a `dry-run` of the included templates:
```bash
helm install --dry-run --debug ./prefect-ui
```

To set specific values at the command line:
```bash
helm install --dry-run --debug ./prefect-ui --set prefect.ui.service.port=8000
```

To package and deploy to helm:
```bash
helm package prefect-ui
mv prefect-ui-0.0.1.tgz prefect-ui/
helm repo index prefect-ui/ --url https://szelenka.github.io/prefect-ui/
cat prefect-ui/index.yaml
```

Then from any machine with Helm installed:
```bash
helm repo add prefect-ui https://szelenka.github.io/prefect-ui
helm repo list
```
```bash
NAME            URL                                        
prefect-ui      https://szelenka.github.io/prefect-ui
```