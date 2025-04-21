FROM nginx:alpine

ENV ACTIVE_COLOR=blue

# Copy the script
COPY start.sh /start.sh

# executable
RUN chmod +x /start.sh

# entrypoint
ENTRYPOINT ["/start.sh"]