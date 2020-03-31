# Submitting Prefect Flows to Kubernetes sans Prefect Cloud

In order for `.register()` to register the Flow on an instance created with this Helm Chart,
we need to ensure we updated our `config.toml` with the appropriate values.

This file can be downloaded from the Website at the domain you provisioned:

    - http://prefect-ui-website.local/backend.toml
    
Then this file needs to be merged with what you have on your local system, which is typically at:
    - ~/.prefect/backend.toml

It's important to note that this will break functionality of sending Flows to Prefect Cloud, but it's easy
to revert back to the default by removing this file from your system:

```bash
rm ~/.prefect/backend.toml
```

The contents of this file are:
```yaml
# https://github.com/PrefectHQ/prefect/blob/master/src/prefect/config.toml

backend = "server"

[server]
host = "http://api.prefect.local"
port = "80"
endpoint = "${server.host}:${server.port}"

    [server.ui]
    host = "http://prefect.local"
    port = "80"
    endpoint = "${server.ui.host}:${server.ui.port}"

[cloud]
# https://github.com/PrefectHQ/prefect/blob/master/src/prefect/agent/docker/agent.py#L384
# config.cloud.api seems to be hardcoded to use host.docker.internal on port 4200 for
api = "${${backend}.endpoint}"
endpoint = "${cloud.api}"
graphql = "${cloud.api}/graphql/alpha"
```