## STRONGSWAN VPN DOCKER

This project was created to simplify the deployment of StrongSwan VPN as a Docker container without the need for a complex configuration.

- Just run the `build_and_run.sh` bash script.
- This will create a Docker container with StrongSwan VPN installed.
- All you need to do is connect your IKEv2 client with the proper configuration.

The project is based on the documentation available at [DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-ikev2-vpn-server-with-strongswan-on-ubuntu-22-04) and allows you to set up a VPN server as a Docker container. The project has been tested on a [DigitalOcean](https://www.digitalocean.com/) VPS running Ubuntu 23.10 with 2GB RAM and 1 CPU.

### REQUIREMENTS
- A VPS server with Docker Compose installed.

### HOW TO USE THE PROJECT
1. Copy the files to your server.
2. Grant execute permissions to `build_and_run.sh`:
   ```
   sudo chmod +x build_and_run.sh
   ```
3. Run ./build_and_run.sh
4. Input VPS_SERVER_IP, USERNAME, PASSWORD 
5. Then script creates Docker container for you.
6. Enter to the container 
````
sudo docker exec -it container_name bash
````
7. Copy ca-cert.pem certificate data to pass to client.
````
cat /etc/ipsec.d/cacert/ca-cert.pem
````
### THAT'S IT

- If you want to add more than one user just enter into the container and manually add some users and passwords
as previous line in the file ipsec.secrets. Do not forget restart container after ipsec.secrets file changing.

````
sudo docker exec -it container_name bash
sudo nano /etc/ipsec.secrets
````

- Try to avoid using symbols as & with username and password when using script. 
It could lead to incorrect file filling.  
