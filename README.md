# prefect-ui

This repository contains a Helm Chart for deploying the Prefect UI to Kubernetes.

## How to consume this Helm Chart on your Kubernetes cluster

First you'll need to add this repository to helm:
```bash
helm repo add prefect-ui https://szelenka.github.io/prefect-ui
```

It should now show up on your system:
```bash
helm repo list

NAME            URL                                        
prefect-ui      https://szelenka.github.io/prefect-ui
```

The last step is to perform an installation. In most cases you'll likely want to review the
[values.yaml](./prefect-ui/values.yaml) to create your customizations during creation. Generally, 
you'd want to modify these values to protect your installation:
```yaml
prefect:
  postgres:
    secrets:
      username: my_unique_username
      password: my_secret_password
      database: my_custom_database_name
    volume:
      storage: "1Gi"
  hasura:
    secrets:
      adminSecret: my_secret_admin_password
  apollo:
    service:
      domainName: domain-for-api.local
  website:
    service:
      domainName: domain-for-user-interface.local

ingress:
  type: ingress || route
  tls: true
  secrets:
    cert: |-
      -----BEGIN CERTIFICATE-----
      MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDB5AVkGh0KVs/6
      ...
      zvHE4SVVq6tCns+PwLuEmyXejSL+vIVzXcHl
      -----END CERTIFICATE-----
    key: |-
      -----BEGIN PRIVATE KEY-----
      MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDB5AVkGh0KVs/6
      ...
      5jRdWWab5Zc2sXy96aeXBA==
      -----END PRIVATE KEY-----
```

Then create the services with your custom values:
```bash
helm install -f my-custom-values.yaml instance-name prefect-ui 
```