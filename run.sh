#!/bin/bash
# Docker build
if [ "$1" == "-v" ]; then
    docker build -t flasm . && docker run -it --rm -p 8000:8000 --platform=linux/amd64 -v $(pwd):/home/ flasm
else
    docker build -t flasm . && docker run -it --rm -p 8000:8000 --platform=linux/amd64 flasm
fi