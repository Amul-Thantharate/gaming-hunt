# Use the official Node.js 16 image 
FROM node:16  

LABEL Sakura="amulthantharate@gmail.com"

# Create and change to the app directory.
WORKDIR /app

# Copy application dependency manifests to the container image.
COPY  package*.json /app/

# Install production dependencies.
RUN npm install 

# Copy local code to the container image.
COPY . /app/

# Run the web service on container startup.
EXPOSE 3000

# Run the web service on container startup.
CMD npm start