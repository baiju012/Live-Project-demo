# Use a base image that includes glibc (required for IBM DB and PAM)
FROM debian:bullseye-slim

# Set environment variables to prevent Python from buffering output
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Update and install required system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libpam0g \
    libpam0g-dev \
    python3 \
    python3-pip \
    python3-dev \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install IBM DB dependencies
RUN wget https://public.dhe.ibm.com/ibmdl/export/pub/software/data/db2/drivers/odbc_cli/linuxx64_odbc_cli.tar.gz \
    && tar -xzf linuxx64_odbc_cli.tar.gz -C /opt/ \
    && rm linuxx64_odbc_cli.tar.gz \
    && ln -s /opt/clidriver/lib/libdb2.so.1 /usr/lib/libdb2.so.1

# Set the working directory in the container
WORKDIR /app

# Copy the application code and requirements
COPY . /app

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Expose the port the app runs on
EXPOSE 5000

# Set the command to run the application
CMD ["python3", "app.py"]
