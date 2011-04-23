class User < ActiveRecord::Base
	attr_accessor :andrew_id
	has_many :events
	
	validates_uniqueness_of :andrew_id
	validates_size_of :andrew_id, :maximum => 50
	
end
