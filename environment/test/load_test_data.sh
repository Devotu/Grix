#!/bin/bash
cypher-shell \
 -a bolt://localhost:7601 \
 -u neo4j \
 -p neo600 \
 --format plain < test_data.cypher
