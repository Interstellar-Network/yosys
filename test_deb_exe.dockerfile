################################################################################

# podman build -f test_deb_exe.dockerfile -t yosys:dev .
# NOTE: it CAN work with Docker but it less than ideal b/c it can not reuse the host's cache
# b/c docker build has no support for volume contrary to podman/buildah
# podman run -it --rm yosys:dev

FROM ubuntu:20.04 as builder

WORKDIR /home/root/

COPY ./build/yosys-0.1.1-Linux.deb /home/root/yosys.deb

# DEBIAN_FRONTEND needed to stop prompt for timezone
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y /home/root/yosys.deb && \
    rm -rf /var/lib/apt/lists/* && \
    rm /home/root/yosys.deb

ENTRYPOINT  ["/usr/bin/yosys_exe"]