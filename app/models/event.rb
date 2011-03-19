class Event < ActiveRecord::Base
	belongs_to :user
	belongs_to :affiliations
	
	validates_presence_of :name, :description, :location, :time, :user_id, :categories
	validates_size_of :name, :user_id, :maximum => 100
	validates_size_of :location, :maximum => 100
	#validates_size_of :categories, :maximum => 2, :message => "You may select at most two categories"
	validates_format_of :name, :description, :location, :with=> /^[a-zA-Z0-9 !.,#\*@:"$\-\?\\\/']*$/
	
	before_validation :cons_categories
	
	has_attached_file :flyer,
		:default_url   => "/system/:attachment/:style/default-flyer.png",
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
		
	def get_similar
		num_events = 3
		query = self.name
		similar = Event.description_like(query).limit(3)
		
		return similar
	end	
		
	def cons_categories
		self.user_id = "byee"
		self.categories = self.categories.join(",")
	end
	
	def validate
		errors.add_to_base "You must either upload a flyer or choose a pattern" if self.flyer.blank? and self.pattern.blank?
	end
	
	
end
