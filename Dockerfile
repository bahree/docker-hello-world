FROM busybox:latest

# Import the environment variables from a file named .env
COPY .env /tmp/.env
ENV PORT=8000

# Load the environment variables from the .env file
RUN export $(cat /tmp/.env | xargs) && \
    echo "PORT is set to ${PORT}"

LABEL maintainer="Chris <c@crccheck.com>"

# Add the HTML template
COPY index.html /www/index.html.template

# Create a startup script to replace placeholders
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

# Expose the port specified in the .env file
EXPOSE ${PORT}

HEALTHCHECK CMD nc -z localhost ${PORT}

# Run the startup script and start the web server
CMD ["/bin/sh", "-c", "/startup.sh && echo 'httpd started' && trap 'exit 0;' TERM INT; httpd -v -p ${PORT} -h /www -f & wait"]
