# Project definitions

Project definitions are stored at `./mackerel/[projectname].yml` (per default).
However that can be overwritten by setting the `mackerel__remote_config_folder` in inventory file.
Each file consists of a **domain** and an **application configuration**.

There are two application types: docker and web. Only one application type is allowed.

## Application Type: docker (recommended)

Docker-based applications are applications that run in one or multiple Docker containers.
The definition is pretty similar to docker-compose. In fact Mackerel uses docker-compose to spin up the containers.

**Note:** Not all container options from docker-compose files are supported right now.

The example above consists of two services (app and db).

```yaml
---
domain: example.com
deployment:
  type: docker
  settings:
    services:
      app:
        image: nginxdemos/hello:latest
        expose_port: 80 # only once per services section!
      db:
        image: mariadb:10.5
        environment:
          MYSQL_ROOT_PASSWORD: example
```

### image (required)

See [docker-compose documentation on image](https://docs.docker.com/compose/compose-file/#image)

### expose_port

The Nginx webserver will proxy all web traffic to the service with `expose_port` setting, which is the container-internal port.
Note that among all services only one is allowed to have `expose_port`!

In the example above, Nginx will proxy web requests to the "app" container's port 80.

### volumes

See [docker-compose documentation on volumes](https://docs.docker.com/compose/compose-file/#volumes).

### environment

See [docker-compose documentation on environment](https://docs.docker.com/compose/compose-file/#environment).

## Application Type: web

Web-based applications are basic applications that live on the target machine and are served by the Nginx webserver.

```yaml
---
domain: example.com
deployment:
  type: web
```

### Serve location

Per default files are served from the `htdocs` folder inside the `/var/www/[projectname]/` directory.
If you want to serve files from a different folder inside that directory, use `deployment.settings.public_path` as below.

```yaml
---
domain: example.com
deployment:
  type: web
  settings:
    public_path: public
```

### Capabilities

If your application requires other software or runtime environments,
define capabilities using `deployment.settings.capabilities` to make sure the application
is only deployed to targets that meet the requirements.

```yaml
---
domain: example.com
deployment:
  type: web
  settings:
    capabilities:
      php:
        version: 7.3
```

Please also have a look at the [complete list of available capabilities](../Features/Capabilities.md).