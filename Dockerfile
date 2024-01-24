# Use the official Node.js 16 image as worker entrypoint
FROM node:16  as worker 

# Create and change to the app directory.
WORKDIR /app

# Copy application dependency manifests to the container image.
COPY  package*.json /app

# Install production dependencies.
RUN npm install 

# Copy local code to the container image.
COPY . /app/

# Run the web service on container startup.
RUN npm run build

FROM nginx:latest

COPY --from=worker /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
