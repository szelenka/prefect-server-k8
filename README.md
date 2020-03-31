# prefect-ui

This repository contains a Helm Chart for deploying the Prefect UI to Kubernetes.

## How to consume this Helm Chart on your Kubernetes cluster

First you'll need to add this repository to helm:
```bash
helm repo add prefect-ui https://szelenka.github.io/prefect-ui/charts
```

It should now show up on your system:
```bash
helm repo list

NAME            URL                                        
prefect-ui      https://szelenka.github.io/prefect-ui/charts
```

The last step is to perform an installation. In most cases you'll likely want to review the
[values.yaml](./prefect-ui/values.yaml) to create your customizations during creation. Generally, 
you'd want to modify these values to protect your installation.

```yaml
prefect:
  minio:
    # each service can be disabled at installation time
    # in this case, we're asking it to NOT install MinIO alongside Prefect UI
    create: false
  postgres:
    secrets:
      # specify the credentials to access Postgres running in a StatefulSet
      username: my_unique_username
      password: my_secret_password
      database: my_custom_database_name
    volume:
      # specify how much persistent storage to give Postgres
      storage: "1Gi"
  hasura:
    secrets:
      # specify the credentials for Hasura
      adminSecret: my_secret_admin_password
  apollo:
    service:
      # specify the externally accessable fully-qualified domain name to access the GraphQL API
      domainName: domain-for-api.local
  website:
    service:
      # specify the externally accessable fully-qualified domain name to access the Vue UI
      domainName: domain-for-user-interface.local

ingress:
  # is this a Kubernetes 'Ingress' or OpenShift 'Route'?
  type: ingress || route
  # do you want TLS on the Ingress/Route?
  tls: true
  secrets:
    # if you want to access the Website and API through HTTPS, specify the certs
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

You can modify any of the values in the [values.yaml](./prefect-ui/values.yaml) this way, but the above would be the most 
common variables to adjust.

Then create the services with your custom values:
```bash
helm install -f my-custom-values.yaml instance-name prefect-ui/prefect-ui
```

## How to register Prefect Flows to this instance

See the [python](./python) folder for an example and details.