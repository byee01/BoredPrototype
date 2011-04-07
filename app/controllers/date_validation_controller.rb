class DateValidationController < ApplicationController

	def parse_date
		Chronic.parse(params[:date], :context => :future).to_s
	end

end
