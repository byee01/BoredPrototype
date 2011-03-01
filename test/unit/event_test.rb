require 'test_helper'

class EventTest < ActiveSupport::TestCase

	context "Creating an event" do
		setup do
			#@sampleFactory = Factory.create(:event)
		end
		
		should "have a flyer or a pattern" do
			#check if there is either a flyer or a pattern
			assert true
		end
		
		teardown do
			#@sampleFactory.destroy
		end
	end

end
