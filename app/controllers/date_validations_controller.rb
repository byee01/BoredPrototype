class DateValidationsController < ApplicationController

respond_to :json
	def show
		#@time = "blah"
		test = Chronic.new
		@time = test.parse(params[:date], :context => :future).to_s
		respond_with @time
	end
end
