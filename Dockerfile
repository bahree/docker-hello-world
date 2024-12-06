FROM busybox:latest

# Create necessary directories
RUN mkdir -p /www/cgi-bin

# Copy the index.html file into the container
COPY index.html /www/index.html

# Copy the CGI script into the container
COPY serverinfo.sh /www/cgi-bin/serverinfo.sh
RUN chmod +x /www/cgi-bin/serverinfo.sh

# Expose port 8000
ENV PORT=8000
EXPOSE ${PORT}

# Start the web server with CGI enabled
CMD ["sh", "-c", "httpd -f -p ${PORT} -h /www -c cgi-bin"]