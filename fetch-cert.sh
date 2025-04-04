#!/bin/sh

# Check if the hvclient container is running
if [ "$(docker ps -q -f name=hvclient)" ]; then
    echo "Stopping and removing the existing hvclient container..."
    docker stop hvclient
    docker rm hvclient
fi

# Pull the docker image from the container registry
docker pull myteqhub/hvclient:latest

echo "Please wait pulling the hvclient image"
sleep 30

# Start the container
docker run -d --name hvclient --volume /home/ubuntu/.hvclient:/root/.hvclient myteqhub/hvclient:latest tail -f /dev/null

sleep 5

# List the name of the running container
CONTAINER_NAME=$(docker ps --format "{{.Names}}" | head -n 1)

# Print the stored container name
echo "Stored Container Name: $CONTAINER_NAME"

# Copy the script inside the container
docker cp /home/ubuntu/hvclient.sh $CONTAINER_NAME:/root/.hvclient/hvclient.sh

# Copy the mTLS cert into the container
#docker cp /home/ubuntu/mTLS.pem $CONTAINER_NAME:/root/.hvclient

# Copy the privatekey into the container
#docker cp /home/ubuntu/privatekey.pem $CONTAINER_NAME:/root/.hvclient

#Make the script executable
docker exec $CONTAINER_NAME chmod +x /root/.hvclient/hvclient.sh

# Run the hvclient.sh script inside the container to generate the files
docker exec $CONTAINER_NAME sh -c 'bash /root/.hvclient/hvclient.sh'
