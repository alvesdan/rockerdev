# rockerdev
Play with Docker + Rails development

##### Dependencies
* Docker
* Docker Compose
* ~~Ruby~~
* ~~Rails~~

```
bash generator.sh
```

What the script does:

* Creates a Dockerfile and docker-compose.yml
* Installs Rails using `template.rb` into the Docker container
* Create a new Rails application in the container

The application will be generated in `./app`. To run the application:

```
cd app
docker-compose up
```

--------------------------

- [x] Generate application from template
- [x] Move Ruby and Rails dependencies to run inside the container
- [ ] Define application name
- [ ] Customize database type
- [ ] Customize services (memcache, redis, elasticsearch)
