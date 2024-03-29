#!/bin/bash

# Check if Docker's GPG key is already added
if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
    echo "Adding Docker's GPG key..."
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
fi

# Check if Docker repository is already in Apt sources
DOCKER_SOURCE_LIST="/etc/apt/sources.list.d/docker.list"
if [ ! -f "$DOCKER_SOURCE_LIST" ]; then
    echo "Adding Docker repository to Apt sources..."
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee "$DOCKER_SOURCE_LIST" > /dev/null
    sudo apt-get update
fi

# Install Docker only if not already installed
if ! type docker > /dev/null 2>&1; then
    echo "Installing Docker..."
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

# Adding the user to the docker group
if [ $(getent group docker) ]; then
    if ! groups $USER | grep -q '\bdocker\b'; then
        echo "Adding $USER to the docker group..."
        sudo usermod -aG docker $USER
        echo "Switching to the docker group in the current shell."
        newgrp docker
    fi
fi

# curl -o docker-compose.yaml -z docker-compose.yaml https://raw.githubusercontent.com/argilla-io/argilla-docker-deploy/main/docker-compose.yaml

# Check if DEFAULT_USER_ENABLED is true
if [ "$ARGILLA_DEFAULT_USER_ENABLED" = "true" ]; then
    # Check if DEFAULT_USER_PASSWORD and DEFAULT_USER_API_KEY are set
    if [ -z "$ARGILLA_DEFAULT_USER_PASSWORD" ] || [ -z "$ARGILLA_DEFAULT_USER_API_KEY" ]; then
        echo "Error: ARGILLA_DEFAULT_USER_PASSWORD and ARGILLA_DEFAULT_USER_API_KEY must be set if DEFAULT_USER_ENABLED is true."
        exit 1
    fi
fi

# Check if Argilla is running, and start it if not
if [ -z "$(docker compose ps -q)" ]; then
    echo "Running Argilla with docker compose..."
    docker compose up -d
fi
