DOCKER_IP = `boot2docker ip`.strip

gem 'therubyracer', platforms: :ruby
gem 'dalli'

file 'Dockerfile', <<-CODE
  FROM ruby:2.2.0
  RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
  RUN mkdir /myapp
  WORKDIR /myapp
  ADD Gemfile /myapp/Gemfile
  RUN bundle install
  ADD . /myapp
CODE

file 'docker-compose.yml', <<-CODE
  db:
    image: postgres
    ports:
      - "5432"

  memcached:
    image: memcached
    ports:
      - "11211:11211"

  web:
    build: .
    command: bundle exec rails s -p 3000 -b '0.0.0.0'
    volumes:
      - .:/myapp
    ports:
      - "3000:3000"
    links:
      - db
      - memcached
CODE

environment "config.action_mailer.default_url_options = { host: '#{DOCKER_IP}', port: 3000 }", env: 'development'
environment "config.action_mailer.asset_host = '#{DOCKER_IP}:3000'", env: 'development'

inject_into_file 'config/application.rb', after: "class Application < Rails::Application\n" do
  "    config.cache_store = :dalli_store, 'memcached'"
end

database_injection = <<-CODE
  host: db
  username: postgres
  password:
CODE

insert_into_file 'config/database.yml', after: "test:\n" do
  database_injection
end

insert_into_file 'config/database.yml', after: "development:\n", force: true do
  database_injection
end

run 'docker-compose build'
run 'docker-compose run web rake db:create'

