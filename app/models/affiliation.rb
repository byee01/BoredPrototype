class Affiliation < ActiveRecord::Base
	has_and_belongs_to_many :events
	
	validates_presence_of :name
	validates_size_of :name, :maximum => 255
	validates_uniqueness_of :name
	validates_format_of :name, :with=> /^[a-zA-Z0-9]* $/
	
end
