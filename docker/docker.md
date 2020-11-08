
## docker 小体会

### 安装

#### 使用阿里云镜像进行安装(官方安装很慢)

> [docker-ce 社区版安装方式](https://developer.aliyun.com/mirror/docker-ce?spm=a2c6h.13651102.0.0.22542f70FK5Avi)

> [docker-镜像阿里云加速](https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors)

### DockerFile ***[官方文档](https://docs.docker.com/engine/reference/builder/)  [网友详解](https://www.jianshu.com/p/11acd40368ad)***

```dockerfile
# 基础镜像
FROM centos:8

# 以/bin/sh -c 执行脚本
RUN soucre /etc/profile
#也可以这样写(其实就是以空格切割成为json数组然后拼起来执行)
RUN ["make","-p","/data/logs/"]
# RUN 命令可有多行,但是一行RUN就是一层commit ,建议和为一行
RUN echo hello

# CMD 为运行容器时提供默认值(只允许有一行,多行存在以最后为准)
CMD /bin/bash

# 切换目录(不存在则创建,不要使用cd,因为镜像构建是多层的)
WORKDIR /home/json

# 容器运行时暴露的端口(默认TCP协议)
EXPOSE 80 443
EXPOSE 80/tcp
EXPOSE 80/udp

#给容器传递环境变量
ENV name=jason
ENV age=18

# 传递本地文件到容器中 ADD <src>  <dest> 支持自动解压
ADD /data/*.log /user/data/

# 复制本地文件到容器中,跟ADD作用类似,推荐COPY
# 特别注意 源路径是相对于Dockerfile的路径,不要跨路径. 建议把dockerfile 提到这些目录的最上层
COPY /data/www/html /user/www/
# ADD和Copy的意义在于容器运行时把文件发送给容器使用

# 文件共享(填写容器绝对路径,默认映射到开启容器的PWD目录)
VOLUME /
```


### Docker 主命令
####  `attach`   进入容器

(Attach local standard input, output, and error streams to a running container)

####  `build` 构建镜像

(Build an image from a Dockerfile)
####  `commit`提交镜像

(Create a new image from a container's changes)
####  `exec`向容器发出指令

(Run a command in a running container)
####  `export`导出容器

(Export a container's filesystem as a tar archive)
####  `images`列举所有镜像

(List images)
####  `info`展示系统信息

(Display system-wide information)
####  `kill`果断杀死容器

(Kill one or more running containers)
####  `logs`展示日志

(Fetch the logs of a container)
####  `port`展示端口映射情况

(List port mappings or a specific mapping for the container)
####  `ps`展示所有容器

(List containers)

####  `restart`  重启容器

(Restart one or more containers)
####  `rm`移除容器

(Remove one or more containers)
####  `rmi`移除镜像

(Remove one or more images)
####  `run`运行容器

(Run a command in a new container)
####  `save`保存镜像

(Save one or more images to a tar archive (streamed to STDOUT by default))
####  `search`搜索镜像

(Search the Docker Hub for images)
####  `start`启动容器

( Start one or more stopped containers)
####  `stats`统计容器情况

(Display a live stream of container(s) resource usage statistics)
####  `stop`停止容器

(Stop one or more running containers)
####  `top`展示容器详细

(Display the running processes of a container)


### Docker Container
#### `docker container --help` 获取更多命令说明

##### docker container exec (向运行的中容器发出指令)

* `docker container exec -it -w /home/ nginx ls` 以交互的方式向* * nginx 切到/home/目录然后ls
* `-w  -- workdir` 指定工作目录
* `-e  --env` 设定环境变量(只对当前bash有效) `-e name=liao`

##### docker container attach (直接切入容器)
* `docker container attach nginx` 以交互的方式向nginx 切到/home/目录然后ls
* `Ctrl+P+Q` 切换到后台,回到主机中

##### docker container export (导出容器)
* `docker container export nginx > nginx.tar` 将容器导出为tar文件

##### docker container 其他常用命令
* `rm`
* `ls`
* `start`
* `restart`
* `logs`

### Docker image
#### `docker image --help` 获取更多命令说明
##### docker container build (基于DockerFile构建一个镜像)
* `docker image build -t nginx:v1 /home/lib/` 以/home/lib/下的dockerFile 文件构建镜像
* `-t  -- tag` 指定镜像名称和标签 'name:tag'
* `-f  -- file` 指定Dockerfile文件名 默认为:'PATH/Dockerfile'

##### docker image import (导入一个镜像)
##### 注意 docker 中导出的容器是作为镜像导入的
##### 示例 `docker import file image_name:tag`
* `docker import nginx.tar new_nginx:v2`
##### docker image 其他常用命令
* `history`
* `inspect`
* `pull`
* `rm`
* `save`


# 第一步 定义dockerfile
```dockerfile
FROM python:3.7-alpine
WORKDIR /code
ENV FLASK_APP app.py
ENV FLASK_RUN_HOST 0.0.0.0
RUN apk add --no-cache gcc musl-dev linux-headers
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY . .
CMD ["flask", "run"]
```

docker run --name some-mysql -v /my/own/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag




# 定义docker-compose.yml
```yaml
version:'3'
services:
  web:
    build: .  // 利用本地dockerfile构建镜像
    ports:
      - "5000:5000"
  redis:
    image: "redis:alpine"
```

```yaml
version: '3'
services:
    nginx:
      image: "nginx:latest"
      ports:
        - "8989:80"
    depends_on:
      - "php"
    php:
      image: "php:7-fpm"

```
# 1 构建一个自己的景象
# 2 搭配redis
```dockerfile
FROM centos
RUN rpm -ivh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
RUN yum -y install nginx
EXPOSE 80/tcp
COPY ./code /usr/share/nginx/html
CMD nginx
```






```yaml
version: '3'
services:
  nginx:
    context: "."
    dockerfile: "Dockerfile"
    command: "/bin/bash"
    volumes:
      - "./code:/usr/share/nginx/html"
    ports:
      - "8686:80"
  redis:
    image: "redis:alpine"
```

```dockerfile
FROM mysql:5.7
COPY ./data: /var/lib/mysql
ENV MYSQL_ROOT_PASSWORD 123456
EXPOSE 3306
```

```dockerfile
FROM redis:6.0
RUN mkdir -p /usr/local/etc/redis
COPY redis.conf /usr/local/etc/redis/redis.conf

#VOLUME /data
EXPOSE 6379
CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]
```
```dockerfile
FROM php:7.4-fpm
RUN docker-php-ext-configure bcmath --enable-bcmath \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql \
    && docker-php-ext-configure pdo_pgsql --with-pgsql \
    && docker-php-ext-configure mbstring --enable-mbstring \
    && docker-php-ext-install \
        bcmath \
        intl \
        mbstring \
        mysqli \
        pcntl \
        pdo_mysql \
        pdo_pgsql \
        sockets \
        zip \
  && docker-php-ext-configure gd \
    --enable-gd-native-ttf \
    --with-jpeg-dir=/usr/lib \
    --with-freetype-dir=/usr/include/freetype2 && \
    docker-php-ext-install gd \
  && docker-php-ext-install opcache \
  && docker-php-ext-enable opcache


```
```yaml
version: '3'
services:
  mysql:
    context: "."
    dockerfile: "Dockerfile"
    command: "/bin/bash"
    volumes:
      - "./code:/usr/share/nginx/html"
    ports:
      - "8686:80"
  redis:
    image: "redis:alpine"
```

```yaml
# Use root/example as user/password credentials
version: '3.1'

services:
  db:
    image: mysql:5.7
    command: --default-authentication-plugin=mysql_native_password
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: 123456
    container_name: mysql5.7
    volumes:
      - ./data:/var/lib/mysql
  ports:
      - 3306:3306

```

```yaml
version: '3.1'

services:
  je:
    image: jenkins
    restart: always
    container_name: myjenkins
    volumes:
      - ./data:/var/jenkins_home
  ports:
      - 8080:8080
      - 50000:50000

```


