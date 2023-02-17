FROM --platform=linux/amd64 ubuntu:22.04
WORKDIR /home

RUN apt-get update
RUN apt-get install -y gdb make nasm binutils gcc tmux netcat
EXPOSE 8000

# Copy files
COPY src src
COPY tst tst
COPY Makefile Makefile

RUN make all

# Have fun :)
RUN /bin/bash
