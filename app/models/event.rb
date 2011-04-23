class Event < ActiveRecord::Base
	belongs_to :user
	belongs_to :affiliations
	
	validates_presence_of :name, :description, :location, :time, :user_id, :categories
	validates_size_of :name, :maximum => 100
	validates_size_of :location, :maximum => 100
	validates_format_of :categories, :with => /^\b0*([1-9]|1[01])(,0*([1-9]|1[01]))?$/, :message => "must be at most two categories"
	validates_numericality_of :user_id
	validates_format_of :name, :description, :location, :with=> /^[a-zA-Z0-9 !.,#\*@:"$\-\?\\\/']*$/
	validates_uniqueness_of :name
	
	validate :check_time_future, :on => :create
	
	before_validation :cons_categories
	
	has_attached_file :flyer,
		:default_url   => "/system/:attachment/:style/default-flyer.png",
		:styles =>{ :small => "200x309", :thumb => "100x155"}

		
	scope :all, order("time ASC")
	scope :upcoming, where("time >= ?", Time.now)

	def pretty_date
		time.strftime("%A, %b. %d - %I:%M%p")
	end
		
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
		self.categories = self.categories.join(",") if not self.categories.nil? and not self.categories.kind_of? String
	end
	
	#def validate
	#	errors.add_to_base "You must either upload a flyer or choose a pattern" if self.flyer.blank? and self.pattern.blank?
		#self.errors.add :time, "Must specify a date in the future" unless ((self.end_time.nil? or self.end_time.future?) and self.time.future?)
	#end
	
	def check_time_future
		self.errors.add :time, "Must specify a date in the future" unless !self.time.nil? and self.time.future?
		#self.errors.add :time,  "Event can't end if it hasn't started" unless (self.end_time.nil? or self.end_time > self.time)
	end
	
	def happening_today?
		return true if self.time.year == Time.now.year and self.time.month == Time.now.month and self.time.day == Time.now.day
	end
	
	def happening_this_week?
		return true if self.time.year == Time.now.year  and self.time.strftime("%U").to_i == Time.now.strftime("%U").to_i
	end
	
	def happening_in_two_weeks?
		return true if self.time.year == Time.now.year  and self.time.strftime("%U").to_i == (Time.now.strftime("%U").to_i + 1)
	end
	
	def happening_in_a_month?
		return true if self.time.year == Time.now.year  and self.time.mon == (Time.now.mon + 1)
	end
	
	def style_list
		s = ""
		
		self.category_list.each{ |c| s << " col#{c.value}"}
		s << " today" if happening_today?
		s << " this_week" if happening_this_week?
		s << " in_two_weeks" if happening_in_two_weeks?
		s << " in_a_month" if happening_in_a_month?
		
		return s
	end
	
	def get_similar
		num_events = 3
		
		similar = Hash.new
		Event.description_like(self.description).limit(num_events).each do |e| 
			next if e.id == self.id
			if similar.key? e
				similar[e] += 1
			else 
				similar[e] = 1
			end 
		end
		
		Event.name_like(self.name).limit(num_events).each do |e| 
			next if e.id == self.id
			if similar.key? e
				similar[e] += 1 
			else 
				similar[e] = 1
			end
		end
		
		Event.categories_like(self.categories).limit(num_events).each do |e| 
			next if e.id == self.id
			if similar.key? e
				similar[e] += 2 
			else 
				similar[e] = 2
			end
		end
		
		Event.time_like(self.time).limit(num_events).each do |e| 
			next if e.id == self.id
			if similar.key? e
				similar[e] += 2 
			else 
				similar[e] = 2
			end
		end
		
		similar = similar.sort_by{|k,v| v}
		similar = similar[0..2].collect{|x| x[0]} #sort by ranking, then return top 3 results
		
		return similar
	end	
end
