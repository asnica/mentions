ruby '2.4.1'
source 'https://rubygems.org'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '>= 5.0.0'

gem 'pg'
gem 'puma'

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'
end

group :test do
  gem 'mocha'
end

group :development do
  gem 'listen'
  gem 'dotenv-rails'
  gem 'ruby-trello'
  gem 'launchy'
end

group :production do
  gem 'rails_12factor'
end
gem 'nokogiri', '>= 1.7.2'
