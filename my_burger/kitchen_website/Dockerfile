# This Dockerfile sets up a slim Python 3.9 environment for running an application.

# Use the official Python 3.9 slim base image to keep the image size small
FROM python:3.9-slim

# Set the working directory in the container to /app
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt requirements.txt

# Install the dependencies from the requirements.txt file without using cache to reduce the image size
RUN pip install --no-cache-dir -r requirements.txt

# Copy all application files from the current directory to the container's working directory
COPY . .

# Expose port 5001 to make the application accessible outside the container
EXPOSE 5001
