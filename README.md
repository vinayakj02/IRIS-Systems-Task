# IRIS-Systems-Task

### Final running website
![image](https://user-images.githubusercontent.com/74676945/172231175-e3f9b309-ebd3-4211-8e62-2ccd04329af2.png)
 <br><br>
![image](https://user-images.githubusercontent.com/74676945/172231909-0357e45f-cebd-43df-94cb-1ada7d55b47c.png)
 <br><br>



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
        ports:
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

![image](https://user-images.githubusercontent.com/74676945/172231314-47bfadfe-6672-489b-a6a7-40c8ac848151.png)  <br><br>
![image](https://user-images.githubusercontent.com/74676945/172231525-975b4efc-afed-4edd-8773-b0ba945ef6ff.png)  <br><br>
![image](https://user-images.githubusercontent.com/74676945/172231713-ff45e1e2-b8bd-4ad4-8406-23e6f9e9d61f.png)  <br><br>


