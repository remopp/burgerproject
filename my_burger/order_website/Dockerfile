# Dockerfile to set up a Python 3.9 environment for the application

# Use the official Python 3.9 slim base image to keep the image size small
FROM python:3.9-slim

# Set the working directory inside the container to /app
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt requirements.txt

# Install the dependencies listed in the requirements.txt file
# Use --no-cache-dir to avoid caching and keep the image size small
RUN pip install --no-cache-dir -r requirements.txt

# Copy all application files from the current directory to the container's working directory
COPY . .

# Expose port 5000 to allow external access to the application
EXPOSE 5000
