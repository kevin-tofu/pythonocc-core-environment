
git clone https://github.com/tpaviot/pythonocc-core.git

pip3 install numpy
# PYTHONOCC_INSTALL_DIRECTORY=$(which python3)
PYTHONOCC_INSTALL_DIRECTORY=$(pyenv prefix)

cd pythonocc-core && \
    mkdir cmake-build && \
    cd cmake-build && \
    echo "include_directories(${NUMPY_INCLUDE_DIR})" >> ../CMakeLists.txt
    cmake \sudo make install && \
     cd ../../
     rm -rf pythonocc-coresudo make install && \
     cd ../../
     rm -rf pythonocc-core
        -DOCCT_INCLUDE_DIR=/opt/occt781/include/opencascade \
        -DOCCT_LIBRARY_DIR=/opt/occt781/lib \
        -DCMAKE_BUILD_TYPE=Release \
        -DPYTHONOCC_INSTALL_DIRECTORY=$(pyenv prefix) \
        -DNUMPY_INCLUDE_DIR=$(python3 -c "import numpy; print(numpy.get_include())") \
        ..  && \
    make -j$(nproc)

sudo make install && \
     cd ../../
     rm -rf pythonocc-core

echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/occt781/lib' >> $HOME/.bashrc
    
CMD ["bash"]
