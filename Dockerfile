FROM busybox:latest

# Import the environment variables from a file named .env
# The .env file should be in the same directory as the Dockerfile
COPY .env /tmp/.env
ENV PORT=8000

# Read the PORT variable from the environment file if it exists, otherwise default to 8000
RUN export $(cat /tmp/.env | xargs) && \
    echo "PORT is set to ${PORT}"

LABEL maintainer="Chris <c@crccheck.com>"

ADD index.html /www/index.html

# Expose the port specified in the .env file
EXPOSE $PORT

HEALTHCHECK CMD nc -z localhost $PORT

# Create a basic webserver and run it until the container is stopped
CMD echo "httpd started" && trap "exit 0;" TERM INT; httpd -v -p $PORT -h /www -f & wait
