#!/bin/bash

docker build -t oqs-openssl-quic-nginx -f Dockerfile-server .

docker build -t oqs-openssl-msquic -f Dockerfile-client .
