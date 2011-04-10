# Load the rails application
require File.expand_path('../application', __FILE__)

config.time_zone = 'Eastern'

# Initialize the rails application
BoredPrototype::Application.initialize!
require 'chronic'