# IRIS-Systems-Task

### Final running website
![image](https://user-images.githubusercontent.com/74676945/172137646-23b22dc4-a0e0-4dd8-a86e-ce024079ee66.png) <br><br>



## Using Docker Compose 
```
version: "3.8"
services:
    db:
        image: "mysql:latest"
        command: mysqld --default-authentication-plugin=mysql_native_password
        environment:
            MYSQL_ROOT_PASSWORD: root
            MYSQL_USERNAME: root
            MYSQL_PASSWORD: root
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
            - "8080:3000"
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
 ````
<br>

- Added [entrypoint.sh](https://github.com/vinayakj02/IRIS-Systems-Task/blob/task-2/Shopping-App-IRIS/entrypoint.sh) , [wait-for-services.sh](https://github.com/vinayakj02/IRIS-Systems-Task/blob/task-2/Shopping-App-IRIS/config/docker/wait-for-services.sh) , [prepare-db.sh](https://github.com/vinayakj02/IRIS-Systems-Task/blob/task-2/Shopping-App-IRIS/config/docker/prepare-db.sh) , [asset-pre-compile.sh](https://github.com/vinayakj02/IRIS-Systems-Task/blob/task-2/Shopping-App-IRIS/config/docker/asset-pre-compile.sh) and modified [database.yml](https://github.com/vinayakj02/IRIS-Systems-Task/blob/task-2/Shopping-App-IRIS/config/database.yml)
- Tested using  ``sudo docker-compose up`` <br>

![image](https://user-images.githubusercontent.com/74676945/172136758-01ef3f07-31d1-480e-ac3d-d06ceae16317.png)<br><br>
![image](https://user-images.githubusercontent.com/74676945/172136823-103c7386-df68-454f-b89a-c4ed4696c4c8.png)



![image](https://user-images.githubusercontent.com/74676945/172137133-0908e573-98d2-4fc0-a06a-676d65d4d53f.png)


