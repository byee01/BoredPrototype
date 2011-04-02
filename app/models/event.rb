class Event < ActiveRecord::Base
	belongs_to :user
	belongs_to :affiliations
	
	validates_presence_of :name, :description, :location, :time, :user_id, :categories
	validates_size_of :name, :maximum => 100
	validates_size_of :location, :maximum => 100
	validates_format_of :categories, :with => /^\b0*([1-9]|1[01])(,0*([1-9]|1[01]))?$/, :message => "You may select at most two categories"
	validates_numericality_of :user_id
	validates_format_of :name, :description, :location, :with=> /^[a-zA-Z0-9 !.,#\*@:"$\-\?\\\/']*$/
	validates_uniqueness_of :name
	
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
		query = self.name #consider creating an array of words
		similar = Event.description_like(query).limit(num_events)
		
		return similar
	end	
		
	def cons_categories
		self.categories = self.categories.join(",") if not self.categories.nil? and not self.categories.kind_of? String
	end
	
	def validate
		errors.add_to_base "You must either upload a flyer or choose a pattern" if self.flyer.blank? and self.pattern.blank?
		#self.errors.add :time, "Must specify a date in the future" unless ((self.end_time.nil? or self.end_time.future?) and self.time.future?)
		self.errors.add :time, "Must specify a date in the future" unless self.time.future?
		self.errors.add :time,  "Event can't end if it hasn't started" unless (self.end_time.nil? or self.end_time > self.time)
	end
	
	
end
