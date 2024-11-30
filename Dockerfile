FROM busybox:latest

# Import the environment variables from a file named .env
COPY .env /tmp/.env
ENV PORT=8000

# Load the environment variables from the .env file
RUN export $(cat /tmp/.env | xargs) && \
    echo "PORT is set to ${PORT}"

LABEL maintainer="Chris <c@crccheck.com>"

# Add the shell script to generate the HTML content
COPY generate_index.sh /generate_index.sh
RUN chmod +x /generate_index.sh

# Add the HTML template
COPY index.html /www/index.html.template

# Run the shell script to generate the HTML content
RUN /bin/sh /generate_index.sh

# Expose the port specified in the .env file
EXPOSE ${PORT}

HEALTHCHECK CMD nc -z localhost ${PORT}

# Create a basic webserver and run it until the container is stopped
CMD echo "httpd started" && trap "exit 0;" TERM INT; httpd -v -p ${PORT} -h /www -f & wait
