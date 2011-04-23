require 'test_helper'

class EventTest < ActiveSupport::TestCase
	should belong_to :user
	
	should_validate_presence_of :name, :description, :location, :time, :user_id, :categories
	should validate_numericality_of :user_id
	should ensure_length_of(:name).is_at_most(100)
	should ensure_length_of(:location).is_at_most(100)
	should_allow_values_for :categories, "1,3", "9,4", "11,10"
	should_not_allow_values_for :name, "<script>sfsfds</script>", "<b>hi</b>"
	should_not_allow_values_for :location, "<script>sfsfds</script>", "<b>hi</b>"
	should_not_allow_values_for :description, "<script>sfsfds</script>", "<b>hi</b>"
	should_not_allow_values_for :categories, "1,3,4", "10,12", "12, 1", "5,13"

	#to test:
	#categories are maintained between creating, editing, and updating
	#either a flyer or a pattern exists
	#test uniqueness of event

	context "Creating an event" do
		setup do
			@sampleEvent = Factory.create(:event)
			@oldEvent = Factory.create(:event, :time => (Time.now - 3424525))
		end
		
		should "have date in future" do
			assert_equal @oldEvent.valid?, false
		end
		
		teardown do
			@sampleEvent.destroy
			@oldEvent.destroy
		end
	end

end
