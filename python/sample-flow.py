# OPTIONAL:
# manually specify the server before the 'prefect' library is imported
# this is an alternative to modifying your ~/.prefect/backend.toml file
import os

os.environ['PREFECT__BACKEND'] = 'server'
os.environ['PREFECT__SERVER__HOST'] = 'http://api.prefect.local'
os.environ['PREFECT__SERVER__PORT'] = '80'
os.environ['PREFECT__SERVER_UI__HOST'] = f'http://prefect.local'
os.environ['PREFECT__SERVER_UI__PORT'] = '80'

from prefect import task, Flow
from prefect.environments.storage import Docker


@task
def extract():
    """Get a list of data"""
    return [1, 2, 3]


@task
def transform(data):
    """Multiply the input by 10"""
    return [_ * 10 for _ in data]


@task
def load(data):
    """Print the data to indicate it was received"""
    print(f"Here's your data: {data}")


with Flow(
    name="ETL",
    storage=Docker(
        registry_url='szelenka',
    )
) as flow:
    e = extract()
    t = transform(data=e)
    l = load(data=t)


if __name__ == '__main__':
    """
    In order for `.register()` to register the Flow on our instance, we need to ensure we updated our `config.toml`
    with the appropriate values.
    
    This file can be downloaded from the Website at:
        - http://prefect-ui-website.local/backend.toml
        
    Then this file needs to be merged with what you have on your local system, which is typically at:
        - ~/.prefect/backend.toml
    """
    import os
    os.environ['PREFECT__BACKEND'] = 'server'
    os.environ['PREFECT__BACKEND_SERVER__ENDPOINT'] = 'http://api.prefect.local'
    os.environ['PREFECT__SERVER__PORT'] = '80'
    os.environ['PREFECT__SERVER_UI__HOST'] = f'http://prefect.local'
    os.environ['PREFECT__SERVER_UI__PORT'] = '80'
    flow.register(
        build=True
    )
