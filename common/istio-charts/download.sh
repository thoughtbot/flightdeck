#!/bin/sh

set -e

mkdir -p "$ARCHIVE_ID"
echo "Downloading $ISTIO_URL"
curl -sL "$ISTIO_URL" -o "$ARCHIVE_ID/istio.tar.gz"
echo "Extracting Istio archive"
cd "$ARCHIVE_ID"
tar zxf istio.tar.gz
