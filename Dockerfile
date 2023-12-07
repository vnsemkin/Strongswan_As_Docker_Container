# Use Ubuntu as the base image
FROM ubuntu:latest

# Install StrongSwan and related packages
RUN apt-get update && apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y strongswan libcharon-extra-plugins libcharon-extauth-plugins libstrongswan-extra-plugins

# Install additional tools
RUN apt-get install -y strongswan-pki
RUN apt-get install -y iptables
RUN apt-get install -y ufw
RUN apt-get install -y nano

# Create directories for Certificate Authority
RUN mkdir -p /etc/ipsec.d/{cacerts,certs,private} && chmod 700 /etc/ipsec.d

# Generate root key and root Certificate Authority
RUN pki --gen --type rsa --size 4096 --outform pem > /etc/ipsec.d/private/ca-key.pem \
    && pki --self --ca --lifetime 3650 --in /etc/ipsec.d/private/ca-key.pem \
       --type rsa --dn "CN=VPN root CA" --outform pem > /etc/ipsec.d/cacerts/ca-cert.pem

# Generate private key for the VPN server
RUN pki --gen --type rsa --size 4096 --outform pem > /etc/ipsec.d/private/server-key.pem

# Generate and sign the VPN server certificate
RUN pki --pub --in /etc/ipsec.d/private/server-key.pem --type rsa \
    | pki --issue --lifetime 1825 \
        --cacert /etc/ipsec.d/cacerts/ca-cert.pem \
        --cakey /etc/ipsec.d/private/ca-key.pem \
        --dn "CN=${VPN_SERVER_IP}" --san @${VPN_SERVER_IP} --san ${VPN_SERVER_IP} \
        --flag serverAuth --flag ikeIntermediate --outform pem \
    > /etc/ipsec.d/certs/server-cert.pem

# Create a new log file
RUN touch /var/log/mylogfile.log && chmod 666 /var/log/mylogfile.log

# Copy the StrongSwan configuration files
COPY ipsec.conf /etc/ipsec.conf
COPY ipsec.secrets /etc/ipsec.secrets

# Expose the necessary ports
EXPOSE 500/udp 4500/udp

# Add entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Start StrongSwan and tail the log file when the container starts
ENTRYPOINT ["/entrypoint.sh"]
