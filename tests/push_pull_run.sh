#!/bin/bash

#build and push
docker buildx build --platform linux/amd64,linux/arm64 -t jonedrengen/isescan:latest --push /Users/B328695/Desktop/Biotools/ISEScan/scripts
docker pull jonedrengen/isescan:latest
docker run --rm jonedrengen/isescan