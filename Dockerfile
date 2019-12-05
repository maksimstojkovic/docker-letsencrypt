# Base image
FROM alpine:latest

# Install tools required
RUN apk --no-cache add certbot curl

# Copy scripts
COPY ./scripts /scripts
WORKDIR /scripts
RUN chmod -R +x /scripts

# Image starting command
CMD ["/bin/sh", "/scripts/start.sh"]
