# IRIS-Systems-Task

### Final running website
![image](https://user-images.githubusercontent.com/74676945/172380199-46429e7c-be63-4e98-a490-8af287eaba30.png)
 <br><br>

![image](https://user-images.githubusercontent.com/74676945/172380431-2c12b7d9-15fe-4b8a-83fd-0cff11ca3abc.png)
<br> <br>


## Using Docker Compose 
- Tested with sudo docker-compose up
```
version: "3.8"
services:
    nginx:
        image: nginx:1.17.10
        container_name: reverse_proxy
        depends_on:
            - db
            - website
        links:
            - website
        volumes:
            - ./reverse_proxy/nginx.conf:/etc/nginx/nginx.conf
        ports:
            - "8080:8080"
        restart: always
    db:
        image: "mysql:latest"
        command: mysqld --default-authentication-plugin=mysql_native_password
        environment:
            MYSQL_ROOT_PASSWORD: root
            MYSQL_USERNAME: root
            MYSQL_PASSWORD: root
        volumes:
            - my-datavolume:/var/lib/mysql
        expose:
            - "3306"
        restart: always
    website:
        command: bash -c "bundle exec rails s -p 3000 -b '0.0.0.0'"
        container_name: "web"
        depends_on:
            - "db"
        links:
            - "db"
        build: .
        expose:
            - "3000"
        environment:
            DB_USERNAME: root
            DB_PASSWORD: root
            DB_DATABASE: shop1_production
            DB_PORT: 3306
            DB_HOST: db
        volumes:
            - ".:/app"
            - "./config/database.yml:/app/config/database.yml"
        restart: always
volumes:
    my-datavolume:
 ````
<br>

- nginx.conf 
```
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
    worker_connections 1024;
}

http {
         server {
            listen 8080;
            server_name localhost 127.0.0.1;
            location / {
                proxy_pass  http://website:3000;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header Host $http_host;
                proxy_set_header X-NginX-Proxy true;
            }
        }
}
```
![image](https://user-images.githubusercontent.com/74676945/172379534-c312abc1-1bb9-4790-8f53-a888f010514c.png)  <br><br>
![image](https://user-images.githubusercontent.com/74676945/172379746-08ae0e95-846f-4034-9122-6c492edcf60f.png) <br> <br>
![image](https://user-images.githubusercontent.com/74676945/172379286-3a5261a4-5955-4c18-af02-2850df54bd83.png)  <br><br>


