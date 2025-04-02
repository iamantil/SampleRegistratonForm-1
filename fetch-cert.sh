#!/bin/sh

# Check if the hvclient container is running
if [ "$(docker ps -q -f name=hvclient)" ]; then
    echo "Stopping and removing the existing hvclient container..."
    docker stop hvclient
    docker rm hvclient
fi

# Pull the docker image from the container registry
docker pull myteqhub/hvclient:latest

echo "Please wait pulling the hvclient nimage"
sleep 30

# Start the container
docker run -d --name hvclient --volume /home/ubuntu/.hvclient:/root/.hvclient myteqhub/hvclient:latest tail -f /dev/null

sleep 5

# List the name of the running container
CONTAINER_NAME=$(docker ps --format "{{.Names}}" | head -n 1)

# Print the stored container name
echo "Stored Container Name: $CONTAINER_NAME"

#Copy the script inside the container
docker cp /home/ubuntu/cicd/SampleRegistratonForm-1/hvclient.sh $CONTAINER_NAME:/root/.hvclient/hvclient.sh

#Make the script executable
docker exec -it $CONTAINER_NAME chmod +x /root/.hvclient/hvclient.sh



#Execute the script into the container
docker exec -d $CONTAINER_NAME /root/.hvclient/hvclient.sh
