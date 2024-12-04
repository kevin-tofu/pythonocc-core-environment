FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /work_dir

RUN apt-get update && \
    apt-get install -y \
        wget \
        libglu1-mesa-dev \
        libgl1-mesa-dev \
        libxmu-dev \
        libxi-dev \
        build-essential \
        cmake \
        libfreetype6-dev \
        tk-dev \
        rapidjson-dev \
        git \
        libpcre2-dev && \
    apt-get clean


RUN wget http://prdownloads.sourceforge.net/swig/swig-4.2.1.tar.gz && \
    tar -zxvf swig-4.2.1.tar.gz && \
    cd swig-4.2.1 && \
    ./configure && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf swig-4.2.1 swig-4.2.1.tar.gz

RUN wget https://github.com/Open-Cascade-SAS/OCCT/archive/refs/tags/V7_8_1.tar.gz && \
    tar -xvzf V7_8_1.tar.gz && \
    cd OCCT-7_8_1 && \
    mkdir cmake-build && \
    cd cmake-build && \
    cmake -DINSTALL_DIR=/opt/occt781 \
          -DBUILD_RELEASE_DISABLE_EXCEPTIONS=OFF \
          .. && \
    make -j$(nproc) && \
    make install && \
    bash -c 'echo "/opt/occt781/lib" >> /etc/ld.so.conf.d/occt.conf' && \
    ldconfig && \
    cd /work_dir && \
    rm -rf OCCT-7_8_1 V7_8_1.tar.gz


RUN pip install numpy

RUN git clone https://github.com/tpaviot/pythonocc-core.git && \
    cd pythonocc-core && \
    mkdir cmake-build && \
    cd cmake-build && \
    echo "include_directories(${NUMPY_INCLUDE_DIR})" >> ../CMakeLists.txt && \
    cmake \
        -DOCCT_INCLUDE_DIR=/opt/occt781/include/opencascade \
        -DOCCT_LIBRARY_DIR=/opt/occt781/lib \
        -DCMAKE_BUILD_TYPE=Release \
        # -DPYTHONOCC_INSTALL_DIRECTORY=/usr/local \
        -DPYTHONOCC_INSTALL_DIRECTORY=$(which python3) \
        -DNUMPY_INCLUDE_DIR=$(python3 -c "import numpy; print(numpy.get_include())") \
        .. && \
    make -j$(nproc) && \
    make install && \
    cd /work_dir && \
    rm -rf pythonocc-core

RUN echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/occt781/lib' >> /root/.bashrc
    
CMD ["bash"]
