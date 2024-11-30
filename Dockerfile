FROM busybox:latest

# Import the environment variables from a file named .env
# The .env file should be in the same directory as the Dockerfile
COPY .env /tmp/.env

# Use the ARG instruction to set the default port
ARG DEFAULT_PORT=8000

# Load the environment variables from the .env file
RUN export $(cat /tmp/.env | xargs) && \
    # Use the value from the .env file or fallback to the default port
    PORT=${PORT:-$DEFAULT_PORT} && \
    echo "PORT is set to ${PORT}"

LABEL maintainer="Chris <c@crccheck.com>"

ADD index.html /www/index.html

# Expose the port specified in the .env file
EXPOSE ${PORT}

HEALTHCHECK CMD nc -z localhost ${PORT}

# Create a basic webserver and run it until the container is stopped
CMD echo "httpd started" && trap "exit 0;" TERM INT; httpd -v -p ${PORT} -h /www -f & wait
