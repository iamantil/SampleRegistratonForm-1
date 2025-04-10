#!/bin/sh
set -e  # Exit on error
set -x  # Debugging: echo commands

# Container name
CONTAINER_NAME=hvclient

# Stop and remove existing container
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Stopping and removing existing container..."
    docker stop $CONTAINER_NAME || true
    docker rm $CONTAINER_NAME || true
fi

# Pull the Docker image with a timeout
echo "Pulling the hvclient image..."
timeout 120s docker pull myteqhub/hvclient:latest || { echo "Image pull failed or timed out"; exit 1; }

# Start the container
docker run -d --name $CONTAINER_NAME \
    -v /home/ubuntu/.hvclient:/root/.hvclient \
    myteqhub/hvclient:latest tail -f /dev/null

# Wait for container to start
sleep 5

# Copy the script into the container
docker cp /home/ubuntu/hvclient.sh $CONTAINER_NAME:/root/.hvclient/hvclient.sh

# Ensure script is executable
docker exec $CONTAINER_NAME chmod +x /root/.hvclient/hvclient.sh

# Run the client script inside the container with a timeout
timeout 600s docker exec $CONTAINER_NAME sh -c '/root/.hvclient/hvclient.sh' || { echo "hvclient.sh failed or hung"; exit 1; }

echo "Script executed successfully"
