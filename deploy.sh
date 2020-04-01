helm package prefect-ui/ -d ./charts
helm repo index ./charts --url https://szelenka.github.io/prefect-ui/charts
git add ./charts