################################################################################
# (from root)
# podman build -f tests/deb/test_deb_lib.dockerfile -t yosys_lib:dev .
# podman run -it --rm yosys_lib:dev

FROM yosys:dev as builder

WORKDIR /home/root/

# DEBIAN_FRONTEND needed to stop prompt for timezone
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    wget unzip xz-utils lsb-release software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# prereq: install CMake
ENV PATH=$PATH:/opt/cmake/bin/
RUN wget https://github.com/Kitware/CMake/releases/download/v3.26.3/cmake-3.26.3-linux-x86_64.sh -O cmake.sh && \
    chmod +x cmake.sh && \
    mkdir /opt/cmake/ && \
    ./cmake.sh --skip-license --prefix=/opt/cmake/ && \
    rm cmake.sh && \
    cmake -version

# prereq: install Ninja (ninja-build)
RUN wget https://github.com/ninja-build/ninja/releases/download/v1.11.1/ninja-linux.zip && \
    unzip ninja-linux.zip -d /usr/local/bin/ && \
    rm ninja-linux.zip && \
    ninja --version

# prereq: install clang
# https://baykara.medium.com/installing-clang-10-in-a-docker-container-4c24a4538af2
# ENV LLVM_VERSION clang+llvm-13.0.1-x86_64-linux-gnu-ubuntu-18.04
# RUN wget https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.1/$LLVM_VERSION.tar.xz && \
#     mkdir -p /opt/$LLVM_VERSION && \
#     tar -xf $LLVM_VERSION.tar.xz -C /opt/$LLVM_VERSION && \
#     mkdir -p /opt/llvm && \
#     mv /opt/$LLVM_VERSION/$LLVM_VERSION/* /opt/llvm && \
#     rm $LLVM_VERSION.tar.xz
# cf https://apt.llvm.org/
RUN wget https://apt.llvm.org/llvm.sh && \
    chmod +x llvm.sh && \
    ./llvm.sh 15 && \
    rm -rf /var/lib/apt/lists/* && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-15 100 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-15 100 && \
    clang --version

COPY ./tests/deb ./tests/deb
RUN cd tests/deb && \
    mkdir build && \
    cd build && \
    cmake -G Ninja .. && \
    cmake --build .

ENTRYPOINT  ["/home/root/tests/deb/build/test_yosys"]