# Hello World

This is a simple Docker image that just gives HTTP responses on a configurable port. It's small enough to fit on one floppy disk 💾:

```bash
$ docker images | grep hello-world
REPOSITORY                      TAG       IMAGE ID        CREATED          VIRTUAL SIZE
amitbahree/hello-world          latest    4f4d0184ae2f   58 minutes ago    4.27MB
```

I made this initially because there were lots of scenarios where I wanted a Docker container that speaks HTTP, but every guide used images that took seconds to download. Armed with a tiny Docker image, I could test things in a fresh environment in under a second. I like faster feedback loops.

## Sample Usage

### Starting a web server on port 80

```bash
$ docker run -d ---rm --name hello-world-test -p 9999:8000 amitbahree/hello-world 
```

You can now interact with this as if it were a dumb web server:

```bash
$ curl localhost
<xmp>
Hello World
Host Name: [hostname]
IP Address: [ip]
Date and Time: [date and time]
...snip...
</xmp>
```

```bash
$ curl -I localhost
HTTP/1.0 200 OK
```

```bash
$ curl -X POST localhost/super/secret
<HTML><HEAD><TITLE>501 Not Implemented</TITLE></HEAD>
...snip...
</HTML>
```

```bash
$ curl --write-out %{http_code} --silent --output /dev/null localhost
200
```

### Building and Publishing to GitHub Registry

To build and publish the image to GitHub Container Registry:

```bash
# Build the Docker image
$ docker build -t amitbahree/hello-world .

# Log in to GitHub Container Registry
$ echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Tag the image
$ docker tag amitbahree/hello-world ghcr.io/amitbahree/hello-world:latest

# Push the image
$ docker push ghcr.io/amitbahree/hello-world:latest
```
