#!/bin/bash
echo "Starting neo4j"
sh ./neo4j.sh
echo "Waiting 5s"
sleep 5s
echo "Loading data"
sh ./load_data.sh
echo "Done"