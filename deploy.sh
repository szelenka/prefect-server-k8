helm package prefect-ui/ -d ./charts
helm repo index ./charts --url https://szelenka.github.io/prefect-server-k8/charts
git add ./charts