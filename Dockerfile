# Use official Python runtime
FROM python:3.9-slim

# Set work directory
WORKDIR /app

# Copy requirements and install
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy application code
COPY . .

# Expose port and run
ENV PORT 8080
CMD ["python", "app.py"]
