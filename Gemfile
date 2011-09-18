source 'http://rubygems.org'

gem 'rails', '3.1.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'uglifier'
end

gem 'therubyracer', :require => 'v8'
gem 'jquery-rails'

# Deploy with to Heroku for testing
# Use postgres for database as Heroku doesn't support sqlite3
group :production do
  gem 'pg'
end

group :development do
  gem 'sqlite3'
  gem 'faker'
end

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end
