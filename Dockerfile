# Use an official Python runtime as a base image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed dependencies specified in requirements.txt
RUN pip install --no-cache-dir boto3 requests pytest

# Copy the test files into the container
COPY testCode.py  /app/tests

# Run tests during the build process
RUN pytest testCode.py

# Run dataExtractor.py when the container launches
CMD ["python", "myCode.py"]
