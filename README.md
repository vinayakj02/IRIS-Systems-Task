# IRIS-Systems-Task

## Rate Limiting

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
        

        limit_req_zone $binary_remote_addr zone=mylimit:10m rate=1r/s;
        # limit_conn_zone $binary_remote_addr zone=per_ip:5m;


            server {
                listen 8080;
                server_name localhost 127.0.0.1;
                location / {

                    limit_req zone=mylimit;

                    proxy_pass http://shoppingapp;
                    proxy_set_header X-Real-IP $remote_addr;
                    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                    proxy_set_header Host $http_host;
                    proxy_set_header X-NginX-Proxy true;

                    
                }
            }
}
```

- Tested using [hey](https://github.com/rakyll/hey), when limit is set to 1 req/s, and 10 requests are made at the same time (10 req/s) with hey, 
![image](https://user-images.githubusercontent.com/74676945/172854243-d83b63e7-60e9-477a-b6ee-29f39e51af3b.png)


- Same limit but 10 requests are made at 1 req/s.
![image](https://user-images.githubusercontent.com/74676945/172854159-d4020bf2-b98e-4abe-bfb3-0f40e1262862.png)





