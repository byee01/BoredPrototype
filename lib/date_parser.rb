module DateParser

	def parse_date(date)
		Chronic.parse(date, :context => :future).to_s
	end
end