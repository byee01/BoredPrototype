class Event < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :affiliations
	
	validates_presence_of :name, :description, :location, :time, :user_id, :categories
	validates_size_of :name, :user_id, :maximum => 50
	validates_size_of :description, :maximum => 255
	validates_size_of :location, :maximum => 100
	validates_size_of :categories, :maximum => 3, :message => "You may select at most two categories"
	validates_format_of :name, :description, :location, :with=> /^[a-zA-Z0-9 !.,#\*@\?\\\/']*$/
	
	before_validation :cons_categories
	
	has_attached_file :flyer,
		:styles =>{ :small => "200x309"}
		
	def category_list
		list = []
		if !self.categories.nil?
			self.categories.split(",").each do |val|
				list << EventsHelper::to_category(val) if !EventsHelper::to_category(val).nil?
			end
		end
		return list
	end
		
	def cons_categories
		self.user_id = "byee"
		self.categories = self.categories.join(",")
	end
	
end