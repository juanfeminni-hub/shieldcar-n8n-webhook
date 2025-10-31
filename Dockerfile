FROM n8nio/n8n:latest

# Expose port
EXPOSE 5678

# Set working directory
WORKDIR /home/node

# Environment variables will be set by Railway
ENV N8N_PORT=5678
ENV N8N_PROTOCOL=https
ENV WEBHOOK_URL=${RAILWAY_STATIC_URL}

# Start n8n
CMD ["n8n"]
