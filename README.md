# HomeBox

HomeBox is the inventory and organization system built for the Home User! With a focus on simplicity and ease of use, Homebox is the perfect solution for your home inventory, organization, and management needs. While developing this project, I've tried to keep the following principles in mind:

* Simple - Homebox is designed to be simple and easy to use. No complicated setup or configuration required. Use either a single docker container, or deploy yourself by compiling the binary for your platform of choice.
* Blazingly Fast - Homebox is written in Go, which makes it extremely fast and requires minimal resources to deploy. In general, idle memory usage is less than 50MB for the whole container.
* Portable - Homebox is designed to be portable and run on anywhere. We use SQLite and an embedded Web UI to make it easy to deploy, use, and backup.

homebox.software

<img src="https://homebox.software/_astro/lilbox.CmeGTiwj_Z1HYzg2.svg" width="30%" height="auto" alt="HomeBox logo">

## How to use this Makejail

### Standalone

Great for testing the application, but not recommended for production deployments. Check out the `appjail-director` example below for a production deployment.

```console
$ mkdir -p /var/appjail-volumes/homebox/data
$ some_random_string=$(openssl rand -base64 48)
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -e HBOX_AUTH_API_KEY_PEPPER="${some_random_string}" \
    -o fstab="/var/appjail-volumes/homebox/data /data" \
    ghcr.io/appjail-makejails/homebox:latest homebox
```

### Deploy using `appjail-director`

**appjail-director.yml**:

```yaml
options:
  - virtualnet: ':<random> default'
  - nat:

services:
  homebox:
    name: homebox
    makejail: gh+AppJail-makejails/homebox
    options:
      - container: 'boot args:--pull'
      - expose: '3100:7745'
    volumes:
      - data: /data
    oci:
      environment:
        - HBOX_LOG_LEVEL: info
        - HBOX_LOG_FORMAT: text
        - HBOX_WEB_MAX_UPLOAD_SIZE: 10
        - HBOX_OPTIONS_ALLOW_ANALYTICS: false
        - HBOX_AUTH_API_KEY_PEPPER: !ENV '${AUTH_API_KEY_PEPPER}'
        - PUID: 15000
        - PGID: 15000
        - TZ: America/Caracas

volumes:
  data:
    device: /var/appjail-volumes/homebox/data
```

**.env**:

```dotenv
DIRECTOR_PROJECT=homebox
AUTH_API_KEY_PEPPER=some_random_string
```

While in the same directory as the `appjail-director.yml` file, run `appjail-director up` to start the container. Then navigate to `http://your-host-ip:3100` (from external hosts) or `http://homebox:7745` (from the same host) to access the HomeBox Web interface.

### Arguments (stage: build)

* `homebox_from` (default: `ghcr.io/appjail-makejails/homebox`): Location of OCI image. See also [OCI Configuration](#oci-configuration).
* `homebox_tag` (default: `latest`): OCI image tag. See also [OCI Configuration](#oci-configuration).

### Environment (OCI image)

* `PGID` (default: `1000`): Equivalent to `PUID` but for the Process Group ID.
* `PUID` (default: `1000`): Process User ID for the container's main process, allowing you to match the owner of files written to mounted host volumes to your host system's user. Writable volumes are changed based on this environment variable.

### Volumes

| Name | Owner | Group | Perm | Type | Mountpoint |
| --- | --- | --- | --- | --- | --- |
| appjail-263aca83a3-data | `${PUID}` | `${PGID}` | - | - | /data |

## OCI Configuration

```yaml
build:
  variants:
    - tag: 15.1
      containerfile: Containerfile
      aliases: ["latest"]
      default: true
      args:
        FREEBSD_RELEASE: "15.1"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
```
