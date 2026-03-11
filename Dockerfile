# Use an official Python runtime as a parent image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies for Docling and ChromaDB
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    libmagic1 \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy requirements first to leverage Docker cache
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Create directories for persistence (ChromaDB and Logs)
RUN mkdir -p db app_logs examples

# Expose the port Gradio runs on
EXPOSE 5000

# Command to run the application
# We use 127.0.0.1 as per your app.py, but for Docker 0.0.0.0 is often required
CMD ["python", "app.py"]
