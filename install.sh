#!/bin/bash

# If no version is specified, fetch the latest version from GitHub Releases.
if [ -z "$1" ]; then
    VERSION=$(curl -s https://api.github.com/repos/loverboykosu/go-cli/releases/latest | grep -o '"tag_name": *"[^"]*"' | sed 's/"tag_name": *"//' | sed 's/"//')
    if [ -z "$VERSION" ]; then
        echo "Failed to fetch the latest version."
        exit 1
    fi
else
    VERSION=$1
fi

OS=$(uname -s)
ARCH=$(uname -m)
URL="https://github.com/loverboykosu/go-cli/releases/download/${VERSION}/go-cli_${OS}_${ARCH}.tar.gz"

echo "Start to install. VERSION=$VERSION, OS=$OS, ARCH=$ARCH"
echo "Download URL=$URL"

TMP_DIR=$(mktemp -d)
curl -L $URL -o $TMP_DIR/go-cli.tar.gz
tar -xzvf $TMP_DIR/go-cli.tar.gz -C $TMP_DIR
sudo mv $TMP_DIR/go-cli /usr/local/bin/go-cli
sudo chmod +x /usr/local/bin/go-cli

rm -rf $TMP_DIR

if [ -f "/usr/local/bin/go-cli" ]; then
  echo "[SUCCESS] go-cli $VERSION installed to /usr/local/bin"
else
  echo "[FAIL] Installation failed."
fi