#!/bin/bash
echo "Exiting neo4j docker"
docker rm $(docker stop  $(docker ps -a -q --filter ancestor=neo4local:ubuntuburken))
echo "Done"

