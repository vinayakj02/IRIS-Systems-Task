# IRIS-Systems-Task

### Final running website
![image](https://user-images.githubusercontent.com/74676945/172380199-46429e7c-be63-4e98-a490-8af287eaba30.png)
 <br><br>

![image](https://user-images.githubusercontent.com/74676945/172380431-2c12b7d9-15fe-4b8a-83fd-0cff11ca3abc.png)
<br> <br>

## Using Docker Compose 

Used volumes with db and nginx config files to persist the data. 
- Tested with sudo docker-compose up
```
version: "3.8"
services:
    nginx:
        image: nginx:1.17.10
        depends_on:
            - db
            - website1
            - website2
            - website3
        links:
            - website1
            - website2
            - website3
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
    website1:
        # command: bash -c "bundle exec rails s -p 3000 -b '0.0.0.0'"
        command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
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
    website2:
        # command: bash -c "bundle exec rails s -p 3000 -b '0.0.0.0'"
        command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
        depends_on:
            - "db"
            - "website1"
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
    website3:
        # command: bash -c "bundle exec rails s -p 3000 -b '0.0.0.0'"
        command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
        depends_on:
            - "db"
            - "website1"
            - "website2"
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

![image](https://user-images.githubusercontent.com/74676945/172433867-bd35d2a0-be22-41ef-9b68-30e381934ea4.png)


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
            upstream shoppingapp {
            server website1:3000 weight=1;
            server website2:3000 weight=1;
            server website3:3000 weight=1;
        }

            server {
                listen 8080;
                server_name localhost 127.0.0.1;
                location / {
                    proxy_pass http://shoppingapp;
                    proxy_set_header X-Real-IP $remote_addr;
                    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                    proxy_set_header Host $http_host;
                    proxy_set_header X-NginX-Proxy true;
                }
            }
}
```

![image](https://user-images.githubusercontent.com/74676945/172432218-2c2f752e-61f2-4cf3-a773-ed7c997052e9.png)
![image](https://user-images.githubusercontent.com/74676945/172432358-b6fee19f-bc31-43bc-a9c2-063d321b2a0f.png)



