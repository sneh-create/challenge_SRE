# Here are the Output to the challenge:

<img width="1384" alt="Screenshot 2024-11-27 at 5 11 58 PM" src="https://github.com/user-attachments/assets/725d1936-4a7c-457f-9fc8-83d09fc6fff7">

<img width="1427" alt="Screenshot 2024-11-27 at 5 12 11 PM" src="https://github.com/user-attachments/assets/67a49c59-e2d9-44aa-a1c1-2419640c2e4f">

<img width="1430" alt="Screenshot 2024-11-27 at 5 12 19 PM" src="https://github.com/user-attachments/assets/fd0ce147-88cf-4930-82eb-9fe99c1c371b">

<img width="1411" alt="Screenshot 2024-11-27 at 5 18 54 PM" src="https://github.com/user-attachments/assets/5fed572b-96ba-4980-b276-51ce246d7f6e">

![Screenshot 2024-11-27 at 5 23 20 PM](https://github.com/user-attachments/assets/5f0b357b-2b2a-4295-a6f6-2b6cbe01f97c)


# Here are instructions to execute the script

1) Install docker and docker-compose

```
sudo apt-get update
sudo apt-get install docker.io docker-compose-v2 -y
sudo usermod -aG docker $USER && newgrp docker
sudo apt install nginx -y
```

2) run the docker compose file
```
docker compose up -d
```
This will install your grafana and jenkins on their respective ports

3) Create a file for the reverse proxy:
```
sudo nano /etc/nginx/sites-available/grafana-jenkins
```
4) Update /etc/hosts:
```
sudo nano /etc/hosts
```
Add:
127.0.0.1 grafana.local
127.0.0.1 jenkins.local

5) Generate Self-Signed Certificate:
```   
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt
```
6) Reload Nginx:
```
sudo nginx -t
sudo systemctl reload nginx
```

7) Secure Jenkins and Grafana with Basic Authentication
Create Authentication File:
```
sudo apt install apache2-utils
sudo htpasswd -c /etc/nginx/.htpasswd admin
```

8) 
