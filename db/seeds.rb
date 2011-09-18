# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'faker'

File.open("db/seed_data.txt").read.each_line do |image|
  name = Faker::Lorem.sentence(num = 2)
  description = Faker::Lorem.sentence
  location = Faker::Address.city
  time = Time.now + ((1+rand(5)) * 60 * 60 * 24)
  flyer = image
  categories = [rand(3)+1, rand(6)+4].join(", ")
  Event.create!(:name => name, :description => description, :location => location, :time => time, :flyer => flyer, :categories => categories) 
end
