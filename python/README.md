# Submitting Prefect Flows to Kubernetes sans Prefect Cloud

In order for `.register()` to register the Flow on an instance created with this Helm Chart,
we need to ensure we updated our `backend.toml` with the appropriate values.

This file can be downloaded from the Website at the domain you provisioned:

    - http://prefect-ui-website.local/backend.toml
    
Then this file needs to be merged with what you have on your local system, which is typically at:
    - ~/.prefect/backend.toml

It's important to note that this will break functionality of sending Flows to Prefect Cloud, as well as attempting to 
launch `prefect server` from the environment where you replace the `backend.toml` file. However, it's easy
to revert back to the default by removing this file from your system:

```bash
rm ~/.prefect/backend.toml
```

The contents of this file are generated at the time this Helm Chart generates the Kubernetes manifest files:
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
api = "${${backend}.endpoint}"
endpoint = "${cloud.api}"
graphql = "${cloud.api}/graphql/alpha"
```

Then you can simply register a Flow as your would normally, and it'll even give you a link to the site after
it registers successfully:
```bash
Flow: http://prefect.local:80/flow/d6c05bd9-ec38-46f1-9af4-f499038e1126
```
