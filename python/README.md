# Submitting Prefect Flows to Kubernetes sans Prefect Cloud

In order for `.register()` to register the Flow on an instance created with this Helm Chart,
we need to ensure we updated our `backend.toml` with the appropriate values.

This file can be downloaded from the Website at the domain you provisioned:

- http://prefect-ui-website.local/backend.toml
    
Then this file needs to be merged with what you have on your local system, which is typically at:

- ~/.prefect/backend.toml

If you use the official documentation to switch between `cloud` and `server`, it will overwrite this file each time:
```bash
prefect backend cloud
prefect backend server
``` 

If you inadvertently call those commands, you can simply replace your `~/.prefect/backend.toml` file with the one
generated on the server you deployed.

The contents of this file are generated at the time this Helm Chart generates the Kubernetes manifest files:
```yaml
# https://github.com/PrefectHQ/prefect/blob/master/src/prefect/config.toml
backend = "server"

[server]
host = "https://api.prefect.local"
port = "443"
endpoint = "${server.host}"

    [server.ui]
    host = "https://prefect.local"
    port = "443"
    endpoint = "${server.ui.host}"
```

Then you can simply register a Flow as your would normally, and it'll even give you a link to the site after
it registers successfully:
```bash
Flow: http://prefect.local/flow/d6c05bd9-ec38-46f1-9af4-f499038e1126
```
