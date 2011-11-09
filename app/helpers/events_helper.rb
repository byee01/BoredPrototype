module EventsHelper
  def closest_half_hour(minute_offset = 0)
    # Ok I spent 30 minutes trying to figure this out but apparently
    # %l returns the hour with some leading whitespace - you need to
    # use .lstrip in order to trim it off the top in order to get it
    # to compare nicely.
    Time.at((Time.now.advance(:minutes => minute_offset*30).to_f / (30*60) ).round * 30*60).strftime("%l:%M %P").lstrip
  end
end
