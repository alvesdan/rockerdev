gem 'therubyracer', platforms: :ruby
gem 'dalli'

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
