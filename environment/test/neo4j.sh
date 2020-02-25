#!/bin/bash
docker run \
    -d \
    --publish=7600:7474 --publish=7601:7687 \
    --mount source=data_600,target=/data \
    --mount source=log_600,target=/logs \
    neo4local:ubuntuburken
