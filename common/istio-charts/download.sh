#!/bin/sh

set -e

echo "Downloading $ISTIO_URL"
curl -sL "$ISTIO_URL" -o istio.tar.gz
echo "Extracting Istio archive"
tar zxf istio.tar.gz
