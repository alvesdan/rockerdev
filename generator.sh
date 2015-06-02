#!/bin/bash

mkdir app
echo "source 'https://rubygems.org'" >> ./app/Gemfile
echo "gem 'rails', '4.2.0'" >> ./app/Gemfile
cp template.rb ./app/template.rb

cat > ./app/Dockerfile <<-EOF
FROM ruby:2.2.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
RUN bundle install
ADD . /app
EOF

cat > ./app/docker-compose.yml <<-EOF
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
    - .:/app
  ports:
    - "3000:3000"
  links:
    - db
    - memcached
EOF

(cd app; docker-compose build)
(cd app; docker-compose run web rails new . --force --database=postgresql -m ./template.rb)
(cd app; docker-compose build)
(cd app; docker-compose run web rake db:create)
