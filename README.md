# HomeBox

HomeBox is the inventory and organization system built for the Home User! With a focus on simplicity and ease of use, Homebox is the perfect solution for your home inventory, organization, and management needs. While developing this project, I've tried to keep the following principles in mind:

* Simple - Homebox is designed to be simple and easy to use. No complicated setup or configuration required. Use either a single docker container, or deploy yourself by compiling the binary for your platform of choice.
* Blazingly Fast - Homebox is written in Go, which makes it extremely fast and requires minimal resources to deploy. In general, idle memory usage is less than 50MB for the whole container.
* Portable - Homebox is designed to be portable and run on anywhere. We use SQLite and an embedded Web UI to make it easy to deploy, use, and backup.

## How to use this Makejail

```
appjail makejail \
    -j homebox \
    -f gh+AppJail-makejails/homebox \
    -o virtualnet=":<random> default" \
    -o nat \
    -o expose=7745
# See available environment variables in https://homebox.software/en/configure.html
appjail start homebox
```

### Arguments

* `homebox_ajspec` (default: `gh+AppJail-makejails/homebox`): Entry point where the `appjail-ajspec(5)` file is located.
* `homebox_tag` (default: `13.5`): see [#tags](#tags).

### Check current status

The custom stage `homebox_status` can be used to run `top(1)` to check the status of HomeBox.

```sh
appjail run -s homebox_status homebox
```

### Log

To view the log generated by the web application, run the custom stage `homebox_log`.

```sh
appjail run -s homebox_log homebox
```

### Volumes

| Name           | Owner | Group | Perm | Type | Mountpoint       |
| -------------- | ----- | ----- | ---- | ---- | ---------------- |
| homebox-data   | 1001  | 1001  |  -   |  -   | /homebox/data    |

## Tags

| Tag           | Arch    | Version            | Type   |
| ------------- | --------| ------------------ | ------ |
| `13.5`    | `amd64` | `13.5-RELEASE` | `thin` |
| `14.3`    | `amd64` | `14.3-RELEASE` | `thin` |
