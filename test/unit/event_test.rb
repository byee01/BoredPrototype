require 'test_helper'

class EventTest < ActiveSupport::TestCase
	should belong_to :user
	
	should_validate_presence_of :name, :description, :location, :time, :user_id, :categories
	should validate_numericality_of :user_id
	should ensure_length_of(:name).is_at_most(100)
	should ensure_length_of(:location).is_at_most(100)
	should_allow_values_for :categories, "1,3", "9,4", "11,10"
	#should_not_allow_values_for :name, "<script>sfsfds</script>", "<b>hi</b>"
	#should_not_allow_values_for :location, "<script>sfsfds</script>", "<b>hi</b>"
	#should_not_allow_values_for :description, "<script>sfsfds</script>", "<b>hi</b>"
	should_not_allow_values_for :categories, "1,3,4", "10,12", "12, 1", "5,13"

	context "Creating an event" do
		setup do
			@sampleEvent = Factory.create(:event)
			@oldEvent = Factory.create(:event, :name => "Tom's Birthday", :time =>  (Time.now  + 2432426))
			@laterEvent = Factory.create(:event, :name => "later event", :time => (Time.now  + 3432425))
		end
		
		should "have date in future" do
			@oldEvent.time = (Time.now - 3424525)
			@oldEvent.save
			assert_not_equal @oldEvent.time,  (Time.now - 3424525)
		end
		
		should "test named scope all" do
			assert_equal ["Something random", "Tom's Birthday", "later event"], Event.all.map{|v| v.name}
		end
				
		teardown do
			@sampleEvent.destroy
			@oldEvent.destroy
			@laterEvent.destroy
		end
	end

end
