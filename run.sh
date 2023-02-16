#!/bin/bash
# Docker build
if [ "$1" == "-v" ]; then
    docker build -t flasm . && docker run -it --rm --platform=linux/amd64 -v $(pwd):/home/ flasm
else
    docker build -t flasm . && docker run -it --rm --platform=linux/amd64 flasm
fi