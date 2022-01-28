FROM ubuntu:focal

ENV TZ=Europe/Zurich
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /root
# Update image and apt software
RUN apt update && apt install software-properties-common apt-utils -y

# Install all prerequisites
RUN apt-add-repository ppa:lttng/stable-2.12 -y && apt update && apt install build-essential cmake liblttng-ust-dev lttng-tools git ninja-build libssl-dev wget -y

# Install powershell as testing requires it:
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb && dpkg -i packages-microsoft-prod.deb && apt-get update && add-apt-repository universe && apt-get install -y powershell

# activate this to only buil plain msquic:
#RUN git clone https://github.com/microsoft/msquic && cd msquic && git submodule init && git submodule update --recursive

# Use this to build oqs-msquic:
RUN git clone --depth 1 --branch main https://github.com/open-quantum-safe/liboqs.git && git clone https://github.com/microsoft/msquic && cd msquic && git submodule deinit -f -- submodules/openssl && rm -rf .git/modules/submodules/openssl && git rm -f submodules/openssl && git submodule add https://github.com/igorbarshteyn/oqs-openssl-quic submodules/openssl && git submodule update --init submodules/googletest && cd ..

# until oqs-openssl builds liboqs as submodule, need to do it manually:
# also copy oqs-includes into a location that the quic-openssl out-of-tree-build will find:
RUN cd liboqs && mkdir build && cd build && cmake -GNinja -DCMAKE_INSTALL_PREFIX=/root/msquic/submodules/openssl/oqs .. && ninja && ninja install && cp -R /root/msquic/submodules/openssl/oqs/include/oqs /root/msquic/submodules/openssl/include

# builds but test would fail b/o powershell dependency of tests:
# RUN cd /root/msquic && mkdir build && cd build && cmake -G 'Unix Makefiles' ..  && cmake --build .

# patch cmake file to find liboqs.a:
COPY src-inc-CMakeLists.txt.patch /root/msquic
RUN patch /root/msquic/src/inc/CMakeLists.txt < /root/msquic/src-inc-CMakeLists.txt.patch

# so, let's build using powershell:
RUN pwsh /root/msquic/scripts/build.ps1 -Config Debug -Arch x64 -Tls openssl

# Note: ipv6 must be enabled for tests to succeed
#RUN pwsh /root/msquic/scripts/test.ps1
