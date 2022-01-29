#!/bin/bash

#OQS-OpenSSL-QUIC Auto-Build Script v0.1 by Igor Barshteyn (CC BY 4.0, January 25, 2022)
#amended by Michael Baentsch

# Set TARGETDIR for updating oqs-openssl to support the QUIC API as developed in quictls:

TARGETDIR=`pwd`

# define known-good OSSL111 tags that may be merged: Change this only when you have
# confirmed both OpenSSL forks, quictls and oqs-openssl have integrated a specific
# upstream tag (1.1.1m in this case):
OQS_OPENSSL_TAG=OQS-OpenSSL-1_1_1-stable-snapshot-2022-01
QUIC_OPENSSL_TAG=OpenSSL_1_1_1m+quic

# Install build prereqs, and set git parameter values (if needed - currently commented out)

sudo apt update && sudo apt install build-essential git cmake gcc libtool libssl-dev make astyle ninja-build python3-pytest python3-pytest-xdist unzip xsltproc doxygen graphviz python3-yaml -y

# Clone required repositories: OQS-OpenSSL, liboqs and quictls-OpenSSL

git clone https://github.com/open-quantum-safe/openssl.git oqs-openssl-quic

git clone --depth 1 https://github.com/open-quantum-safe/liboqs.git

git clone --branch $QUIC_OPENSSL_TAG https://github.com/quictls/openssl.git quictls

# Locate the QUIC commits to cherry pick, checkout oqs-openssl branch, add quictls,
# fetch it, then automatically cherry pick them to oqs-openssl, favoring quictls
# for conflict resolution

# It is very useful here that the quictls team tagged all their QUIC commits (and only these) with "QUIC:"

cd $TARGETDIR/quictls

LAST_CHERRY=$(git log --grep "QUIC:" --format=format:%H | sed -e 1q)
FIRST_CHERRY=$(git log --grep "QUIC:" --format=format:%H | tail -n 1)

cd $TARGETDIR/oqs-openssl-quic

git checkout $OQS_OPENSSL_TAG

git remote add $QUIC_OPENSSL_TAG ../quictls

git fetch $QUIC_OPENSSL_TAG 

git cherry-pick $FIRST_CHERRY^..$LAST_CHERRY -Xtheirs -n

# Update version name to indicate both QUIC+OQS support
sed -i "s/quic/quic\+$OQS_OPENSSL_TAG/g" include/openssl/opensslv.h

# Build liboqs, then build out oqs-openssl-quic and install it
cd $TARGETDIR/liboqs

mkdir build && cd build && cmake -GNinja -DCMAKE_INSTALL_PREFIX=$TARGETDIR/oqs-openssl-quic/oqs .. && ninja && ninja install

# Configure, build, and verify custom version of oqs-openssl with QUIC support (enable all PQ and hybrid KEMs)
cd $TARGETDIR/oqs-openssl-quic

./Configure '-Wl,--enable-new-dtags,-rpath,$(LIBRPATH)' no-shared linux-x86_64 -DOQS_DEFAULT_GROUPS=\"bikel1:bikel3:kyber512:kyber768:kyber1024:kyber90s512:kyber90s768:kyber90s1024:frodo640aes:frodo640shake:frodo976aes:frodo976shake:frodo1344aes:frodo1344shake:hqc128:hqc192:hqc256:ntru_hps2048509:ntru_hps2048677:ntru_hps4096821:ntru_hps40961229:ntru_hrss701:ntru_hrss1373:ntrulpr653:ntrulpr761:ntrulpr857:ntrulpr1277:sntrup653:sntrup761:sntrup857:sntrup1277:lightsaber:saber:firesaber:sidhp434:sidhp503:sidhp610:sidhp751:sikep434:sikep503:sikep610:sikep751:p256_bikel1:p384_bikel3:p256_kyber512:p384_kyber768:p521_kyber1024:p256_kyber90s512:p384_kyber90s768:p521_kyber90s1024:p256_frodo640aes:p256_frodo640shake:p384_frodo976aes:p384_frodo976shake:p521_frodo1344aes:p521_frodo1344shake:p256_hqc128:p384_hqc192:p521_hqc256:p256_ntrulpr653:p256_ntrulpr761:p384_ntrulpr857:p521_ntrulpr1277:p256_sntrup653:p256_sntrup761:p384_sntrup857:p521_sntrup1277:p256_ntru_hps2048509:p384_ntru_hps2048677:p521_ntru_hps40961229:p521_ntru_hps4096821:p384_ntru_hrss701:p521_ntru_hrss1373:p256_lightsaber:p384_saber:p521_firesaber:p256_sidhp434:p256_sidhp503:p384_sidhp610:p521_sidhp751:p256_sikep434:p256_sikep503:p384_sikep610:p521_sikep751\" -lm --prefix=$TARGETDIR/install

make -j 2 && make install_sw

clear

# Should output OpenSSL+quic+OQS release:
$TARGETDIR/install/bin/openssl version -a

git checkout -b "$OQS_OPENSSL_TAG-quic"

# For sanity check oqs-openssl-quic still does OQS-TLS OK:
# commit only when we know everything tests OK
# python3 -m pytest oqs-test/test_tls_basic.py && git commit -m "merging in $QUIC_OPENSSL_TAG"

