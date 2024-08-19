# Base image for all environments
FROM node:18-alpine AS base
WORKDIR /app

# Copy package files for installing dependencies
COPY package.json package-lock.json ./

# Use a build argument to define the environment (default to production)
ARG ENV=prod

# Install dependencies based on the environment
RUN if [ "$ENV" = "dev" ]; then npm install; else npm ci --only=production; fi

# Copy the application code after dependencies have been installed
COPY . .

# Separate production stage
FROM node:18-alpine AS prod
WORKDIR /app

# Copy files from the base stage
COPY --from=base /app /app

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Expose the port the application will run on
EXPOSE 3000

# Start the application
CMD [ "npm", "start" ]

# Separate stage for development
FROM node:18-alpine AS dev
WORKDIR /app

# Copy files from the base stage
COPY --from=base /app /app

# Set environment variables for development
ENV NODE_ENV=development
ENV PORT=3000

# Expose the port for development environment
EXPOSE 3000

# Start the application in development mode
CMD [ "npm", "run", "dev" ]

# Separate stage for staging (similar to production)
FROM node:18-alpine AS stag
WORKDIR /app

# Copy files from the base stage
COPY --from=base /app /app

# Set environment variables for staging
ENV NODE_ENV=staging
ENV PORT=3000

# Expose the port for staging environment
EXPOSE 3000

# Start the application in staging mode
CMD [ "npm", "start" ]