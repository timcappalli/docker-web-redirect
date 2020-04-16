# Docker-Web-Redirect #

This Docker container listens on port 80 and redirects all web traffic permanently to the given target domain/URL.

## Features ##
- Lightweight: Uses only ~2 MB RAM on Linux
- Keeps the URL path and GET parameters
- Configurable redirect type (301 vs 302)

## Usage ##
### Docker run ###
The target domain/URL is set by the `REDIRECT_TARGET` environment variable.  

Possible redirect targets include domains (`mydomain.net`), paths (`mydomain.net/my_page`) or specific protocols (`https://mydomain.net/my_page`).

Redirect type is set by the `REDIRECT_TYPE` environment variable. Unset: redirect (302), "permanent": permanent (301).

**Example:** `$ docker run --rm -d -e REDIRECT_TARGET=mydomain.net -p 80:80 morbz/docker-web-redirect`

### Paths are retained ###
The URL path and GET parameters are retained. That means that a request to `http://myolddomain.net/index.php?page=2` will be redirected to `http://mydomain.net/index.php?page=2` when `REDIRECT_TARGET=mydomain.net` is set.

## Docker Compose ##
This image can be combined with the [jwilder nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy/). A sample docker-compose file that redirects `myolddomain.net` to `mydomain.net` could look like this:

```yaml
version: '3'
services:
  redirect:
    image: morbz/docker-web-redirect
    restart: always
    environment:
      - VIRTUAL_HOST=myolddomain.net
      - REDIRECT_TARGET=mydomain.net
```
