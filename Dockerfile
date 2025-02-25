# Dockerfile
FROM node:16

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json (if it exists)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React app for production
RUN npm run build

# Install a simple HTTP server to serve the built app
RUN npm install -g serve

# Expose the port
EXPOSE 80

# Start the application using the serve command
CMD ["serve", "-s", "build", "-l", "80"]
