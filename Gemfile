source 'http://rubygems.org'

gem 'rails', '3.1.0'
gem 'rake', '0.8.7'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # gem 'therubyracer'
  gem 'sass-rails', "  ~> 3.1.0"
  # gem 'uglifier'
end

gem 'jquery-rails'
gem 'paperclip', '~>2.4'

# Deploy with to Heroku for testing
# Use postgres for database as Heroku doesn't support sqlite3
group :production do
  gem 'pg'
  # gem 'faker'   # Temporary for seeding purposes(?)
end

group :development do
  gem 'sqlite3'
  # gem 'faker'
end

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end
