# Hello World

This is a simple Docker image that just gives HTTP responses on a configurable port. It's small enough to fit on one floppy disk 💾:

```bash
$ docker images | grep hello-world
REPOSITORY                      TAG       IMAGE ID        CREATED          VIRTUAL SIZE
amitbahree/hello-world          latest    4f4d0184ae2f   58 minutes ago    4.27MB
```

I made this initially because there were lots of scenarios where I wanted a Docker container that speaks HTTP, but every guide used images that took seconds to download. Armed with a tiny Docker image, I could test things in a fresh environment in under a second. I like faster feedback loops.

## Sample Usage

### Starting a web server on port 9999

```bash
$ docker run -d --rm -p 9999:8000 amitbahree/hello-world 
```

You can now interact with this as if it were a dumb web server:

```bash
$ curl http://localhost:9999
<!DOCTYPE html>
<html>
<head>
    <title>Hello World</title>
</head>
<body>
    <h2>Hello World</h2>
    <p>This is a simple web page served by a container to test that things are working correctly.</p>
    <p>Given you are reading this, shows that things are working correctly. :)</p>
    <pre>
                                          ##         .
                                    ## ## ##        ==
                                 ## ## ## ## ##    ===
                              /""""""""""""""""\___/ ===
                        ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~
                              \______ o          _,/
                               \      \       _,'
                                `'--.._\..--''
    </pre>
    <h3>Server Information</h3>
    <p><strong>Hostname:</strong> <span id="hostname"></span></p>
    <p><strong>IP Address:</strong> <span id="ip_address"></span></p>
    <p><strong>Date and Time:</strong> <span id="date_time"></span></p>
    <p><strong>Uptime:</strong> <span id="uptime"></span></p>
    <p><strong>Server Details:</strong> <span id="server_details"></span></p>
    ...
</body>
</html>
```

```bash
$ curl -I http://localhost:9999
HTTP/1.1 200 OK
Date: Sun, 01 Dec 2024 00:42:38 GMT
Connection: close
Content-type: text/html
Accept-Ranges: bytes
Last-Modified: Sun, 01 Dec 2024 00:29:53 GMT
ETag: "674bae01-72b"
Content-Length: 1835
```

```bash
$  curl -X POST http://localhost:9999/some/secret
<HTML><HEAD><TITLE>501 Not Implemented</TITLE></HEAD>
<BODY><H1>501 Not Implemented</H1>
The requested method is not recognized
</BODY></HTML>
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
