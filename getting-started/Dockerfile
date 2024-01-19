# Use the Nginx image from Docker Hub as the base image
FROM nginx:alpine

# Remove the default Nginx configuration file
RUN rm /etc/nginx/conf.d/default.conf

# Copy a new configuration file from the local directory to the container
COPY nginx.conf /etc/nginx/conf.d

# Remove the default Nginx HTML file
RUN rm -rf /usr/share/nginx/html/*

# Copy a new HTML file from the local directory to the container
COPY index.html /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx when the container has provisioned.
CMD ["nginx", "-g", "daemon off;"]
