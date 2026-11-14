#!/bin/bash
set -e

CONTAINER_NAME="block1-garage"
BUCKET_NAME="scc-audit-logs"
KEY_NAME="scanner-key"

echo "[*] Checking if Garage container is running..."
if [ ! "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "[!] Container $CONTAINER_NAME is not running. Please start it with docker compose first."
    exit 1
fi

echo "[*] Extracting Node ID..."
NODE_ID=$(docker exec -it $CONTAINER_NAME ./garage status | awk 'NR==3 {print $1}' | tr -d '\r')

if [ -z "$NODE_ID" ]; then
    echo "[!] Failed to extract Node ID."
    exit 1
fi
echo "[+] Found Node ID: $NODE_ID"

echo "[*] Assigning cluster layout..."
docker exec -it $CONTAINER_NAME ./garage layout assign -z dc1 -c 10G $NODE_ID || true

echo "[*] Applying layout version..."
docker exec -it $CONTAINER_NAME ./garage layout apply --version 1 || true

echo "[*] Creating audit bucket ($BUCKET_NAME)..."
docker exec -it $CONTAINER_NAME ./garage bucket create $BUCKET_NAME || true

echo "[*] Creating security scanner access key ($KEY_NAME)..."
docker exec -it $CONTAINER_NAME ./garage key create $KEY_NAME || true

echo "[*] Linking key to bucket..."
docker exec -it $CONTAINER_NAME ./garage bucket allow --read --write --owner $BUCKET_NAME --key $KEY_NAME || true

echo "[+] Block 1 Storage & Cluster Initialization Complete!"