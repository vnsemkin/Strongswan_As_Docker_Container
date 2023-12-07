#!/bin/bash

# Prompt user for input
read -p "Enter VPN Server IP: " VPN_SERVER_IP
read -p "Enter Username: " USERNAME
read -p "Enter Password: " PASSWORD

# Save original files
cp Dockerfile Dockerfile.orig
cp ipsec.conf ipsec.conf.orig
cp ipsec.secrets ipsec.secrets.orig

# Update the Dockerfile file with the correct VPN server IP
sed -i "s|\${VPN_SERVER_IP}|$VPN_SERVER_IP|g" Dockerfile

# Update the ipsec.conf file with the correct VPN server IP
sed -i "s|\${VPN_SERVER_IP}|$VPN_SERVER_IP|g" ipsec.conf

# Update the ipsec.secrets file with the correct username and password
sed -i "s|\${USERNAME}|$USERNAME|g" ipsec.secrets
sed -i "s|\${PASSWORD}|$PASSWORD|g" ipsec.secrets

# Build and run the Docker container using docker-compose
docker-compose up --build -d

# Restore original files
mv Dockerfile.orig Dockerfile
mv ipsec.conf.orig ipsec.conf
mv ipsec.secrets.orig ipsec.secrets
