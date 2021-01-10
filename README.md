# Dockerizing Ruby On Rails
This is a Docker setup for creating projects with Ruby on Rails using Postgresql as database engine.

With this configuration, it is intended that the installation of a ruby on rails project in the local environment can be easier and faster, without the need to install all the resources on our machine. This also helps local environments to be the same regardless of the computer where you work.

- Ruby version: 2.7.1
- Rails version: 6.0.3
- System dependencies
Built with docker 19.03.12 and docker-compose 1.21

**Note**
For production environment, docker files must be modified.

# Prerequisites
- Docker basic concepts
It is necessary that you have basic knowledge of Docker, it's recommended that you refer to [Docker Overview](https://docs.docker.com/get-started/overview/)

- Install Docker and Docker Compose
You can check of oficial page of Docker where you find the installation for [Docker Engine](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/)
This setup requires the installation of Docker and Docker Compose, check the versions so you don't have trouble with the step by step.
You can also try other versions of Docker Engine and Docker Compose, sometimes the steps are similar.

# Get Started
This setup works for app or api with ruby on rails. The words owner_name and project_name could be changes for names that corresponding to your project.

### APP Ruby on Rails
1. Build docker image
`$ sudo docker build -t owner_name/project_name .`
The image will be built from a **ruby 2.7.1-slim** image and will have yarn, node, and postgres.
Remember to change the names of **owner_name** and **project_name** to the names you needs and modify the image name in **docker-compose.yml**

2. Change mod of **docker-entrypoint.sh**
`$ chmod 777 docker-entrypoint.sh`
It is possible that when executing the docker commands a problem is generated with this file, for this reason the file mode is changed.

3. Create Ruby on Rails project
`$ sudo docker-compose run web rails new project_name -d postgresql --skip-javascript`

4. Change own of project file
``$ sudo chown -R `whoami` project_name/``
Due we generate our rails project from docker, the owner with which docker generates these files does not coincide with that of our machine, so we run this line to avoid inconveniences when the files ar edited.

5. Move docker files to new project
```sh
$ mv docker-compose.yml project_name/
$ mv docker-entrypoint.sh project_name/
$ mv Dockerfile project_name/
```

6. Enter to folder project
```sh
$ cd project_name
```

7. In the ***database.yml*** set the next lines
```ruby
default: &default
  adapter: postgresql
  encoding: unicode
  host: postgres
  username: postgres
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
```

8. Run rails app
`sudo docker-compose up`

9. Go to ***localhost:3000*** in your web browser

### API Ruby on Rails
1. Remove the yarn and node installation from **Dockerfile**, the file should look like this
```sh
FROM ruby:2.7.1-slim

ENV LC_ALL=C.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

RUN apt-get update && apt-get install curl wget gnupg2 -y && \
    rm -rf /var/lib/apt/lists/*

# Add Pqsl
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update && apt-get install postgresql-client-12 build-essential \
    bc imagemagick libcurl4-openssl-dev libpq-dev iproute2 openssh-server git -y && \
    rm -rf /var/lib/apt/lists/*

RUN gem install bundler

RUN mkdir /project_name
WORKDIR /project_name

ENTRYPOINT ["./docker-entrypoint.sh"]
```

2. Build docker image
`$ sudo docker build -t owner_name/project_name .`
The image will be built from a **ruby 2.7.1-slim** image and will have yarn, node, and postgres.
Remember to change the names of **owner_name** and **project_name** to the names you needs and modify the image name in **docker-compose.yml**

3. Change mod of **docker-entrypoint.sh**
`$ chmod 777 docker-entrypoint.sh`
It is possible that when executing the docker commands a problem is generated with this file, for this reason the file mode is changed.

4. Create Ruby on Rails project
`$ sudo docker-compose run web rails new project_name --api --d postgresql`

5. Change own of project file
``$ sudo chown -R `whoami` project_name/``
Due we generate our rails project from docker, the owner with which docker generates these files does not coincide with that of our machine, so we run this line to avoid inconveniences when the files ar edited.

6. Move docker files to new project
```sh
$ mv docker-compose.yml project_name/
$ mv docker-entrypoint.sh project_name/
$ mv Dockerfile project_name/ 
```

7. Enter to folder project
```sh
$ cd project_name
```

8. In the ***database.yml*** set the next lines
```ruby
default: &default
  adapter: postgresql
  encoding: unicode
  host: postgres
  username: postgres
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
```

9. Run rails app
`sudo docker-compose up`

10. Go to ***localhost:3000*** in your web browser
