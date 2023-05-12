################################################################################
# (from root)
# podman build -f tests/deb/test_deb_exe.dockerfile -t yosys:dev .
# podman run -it --rm yosys:dev

FROM ubuntu:22.04 as builder

WORKDIR /home/root/

COPY ./build/yosys-0.1.29-Linux.deb /home/root/yosys.deb

# DEBIAN_FRONTEND needed to stop prompt for timezone
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y /home/root/yosys.deb && \
    rm -rf /var/lib/apt/lists/* && \
    rm /home/root/yosys.deb

ENTRYPOINT  ["/usr/bin/yosys_exe"]