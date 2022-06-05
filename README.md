# IRIS-Systems-Task

## Task 1 
### Dockerfile 
```
FROM ruby:2.5.1-stretch
RUN apt-get update -qq && apt-get install -y nodejs && apt-get install -y mysql-server
WORKDIR /app
 
COPY Gemfile Gemfile.lock  ./

RUN bundle update mimemagic
RUN bundle install 
 
COPY . .  
 
# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000


CMD ["rails", "server", "-b", "0.0.0.0"]
```
## Final running page
![image](https://user-images.githubusercontent.com/74676945/172048060-fbca1101-b821-4763-b068-2dc6e51312c7.png)

### To build the image 

`` sudo docker build -t railsss . `` <br><br>
![image](https://user-images.githubusercontent.com/74676945/172047690-c939f549-257d-4bac-84f3-37ca4eca564a.png) 


### Image created 
```sudo docker images``` <br> <br>
![image](https://user-images.githubusercontent.com/74676945/172047790-bfc02e59-c4ea-4be2-aa95-7bab498bb7e2.png)


### Run the container 
``sudo docker run -p 3000:3000 railsss:latest`` <br> <br>
![image](https://user-images.githubusercontent.com/74676945/172047983-5375a258-d9cd-4007-ac7a-5d40f781ab35.png)

![image](https://user-images.githubusercontent.com/74676945/172047993-17338841-4d62-4f7c-ab85-c42269375a94.png)


