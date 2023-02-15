#!/bin/bash
# Docker build
docker build -t flasm . && docker run -it --rm --platform=linux/amd64 flasm