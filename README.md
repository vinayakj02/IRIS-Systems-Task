# IRIS Systems Task

## Final Running site 
![image](https://user-images.githubusercontent.com/74676945/173151466-7693fef2-c068-4871-9e59-8e143d4c6a92.png)
![image](https://user-images.githubusercontent.com/74676945/173151542-b75b6af9-94e7-42fb-9fb9-3609256a69b9.png)



## Tasks 
| Task | Branch | Description |   
| ------------- | ------------- | ------------ |
| 1 | [Branch 1](https://github.com/vinayakj02/IRIS-Systems-Task/tree/task-1)  |  Dockerized the app with one image/container  | 
| 2 | [Branch 2](https://github.com/vinayakj02/IRIS-Systems-Task/tree/task-2) | Used Docker compose to launch seperate container for db without exposing db port outside docker network |
| 3 | [Branch 3](https://github.com/vinayakj02/IRIS-Systems-Task/tree/task-3) | Nginx as reverse proxy | 
| 4 | [Branch 4-5-6](https://github.com/vinayakj02/IRIS-Systems-Task/tree/task-4-5-6) | Scaled to 3 web containers and load balance requests |
| 5 | [Branch 4-5-6](https://github.com/vinayakj02/IRIS-Systems-Task/tree/task-4-5-6) | Persistence using Volumes |  
| 6 | [Branch 4-5-6](https://github.com/vinayakj02/IRIS-Systems-Task/tree/task-4-5-6) | Docker compose | 
| 7 | [Branch 7](https://github.com/vinayakj02/IRIS-Systems-Task/tree/task-7) |  Added requests rate limit  | 
| 8 | This branch | Made another container to create cron job to create database backups everyday | 




<br>

## Docker compose file for task 8

```
version: "3.8"
services:
    mysql-cron-backup:
        image: fradelg/mysql-cron-backup
        depends_on:
            - db
        volumes:
            - /backup:/backup
        environment:
            - MYSQL_HOST=db
            - MYSQL_USER=root
            - MYSQL_PASS=root
            - MAX_BACKUPS=15
            - INIT_BACKUP=0
            #- CRON_TIME=* * * * *  # every minute
            - CRON_TIME=0 0 * * * # for backup at midnight everyday
            - GZIP_LEVEL=9
        restart: unless-stopped

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
        cap_add:
            - SYS_NICE
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
```
- Available backups
    ![image](https://user-images.githubusercontent.com/74676945/173151944-c003f69d-1c82-41e4-829c-0d27b81f9b89.png)

(made backup every minute for testing)

- used mysql-cron-backup image from [fradelg](https://github.com/fradelg/docker-mysql-cron-backup) 


