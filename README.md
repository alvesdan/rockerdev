# rockerdev
Play with Docker + Rails development

##### Dependencies
* Docker
* Docker Compose
* Ruby
* Rails

```
bash generator.sh
```

The script will use **template.rb** file to:

* Create a Rails APP
* Inject required configuration code
* Create a Dockerfile
* Create a docker-compose.yml file
* Build the Docker container

The application will be generated in `./app`. To run the application:

```
cd app
docker-compose up
```

--------------------------

- [x] Generate application from template
- [ ] Move Ruby and Rails dependencies to run inside the container
- [ ] Define application name
- [ ] Customize database type
- [ ] Customize services (memcache, redis, elasticsearch)
