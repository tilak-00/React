# Use official Node.js runtime as base image
FROM node:16 AS build

# Set working directory inside container
WORKDIR /app

# Copy package.json and package-lock.json first (for caching layers)
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the application code
COPY . .

# Build the react app for production 
RUN npm run build

# step2: setup up the production environment to server
FROM nginx:alpine

# Copy React build output to Nginx default directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Run Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
