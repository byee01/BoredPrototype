class Event < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :affiliations
	
	validates_presence_of :name, :desc, :location, :time, :user_id, :categories
	validates_size_of :name, :user_id :maximum => 50
	validates_size_of :description, :image,  :maximum => 255
	validates_size_of :location, :maximum => 100
	validates_size_of :categories, :maximum => 2
	validates_format_of :name, :desc, :location, :with=> /^[a-zA-Z0-9]* $/
	
	
end
