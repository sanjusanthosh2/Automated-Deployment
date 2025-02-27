# Use a lightweight web server
FROM nginx:alpine

# Copy the static website files to the container
COPY store.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

# Start Nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]
