#!/bin/bash
docker run \
    -d \
    --publish=7600:7474 --publish=7601:7687 \
    --mount source=data_grix_live,target=/data \
    --mount source=log_grix_live,target=/logs \
    neo4local:ubuntuburken
