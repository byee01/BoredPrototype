include ActionView::Helpers::DateHelper

class Event < ActiveRecord::Base
  validates_presence_of :name, :description, :location, :start_time, :end_time, :categories
  validates_size_of :location, :maximum => 100
  ### validates_format_of :name, :location, :with => /^[a-zA-Z0-9 !.,#\*<>@&:"$\-\\\/']*$/


  #### SCOPES ####
  scope :all, order("start_time ASC")
  scope :upcoming, where("start_time >= ?", Time.now)


  #### PAPERCLIP ####
  has_attached_file :flyer

  #### DATA ####
  EVENT_TIMES = ["12:00 am", "00:00"], ["12:30 am", "00:30"], ["1:00 am", "1:00"], ["1:30 am", ], ["2:00 am", ], ["2:30 am", ], ["3:00 am", ], ["3:30 am", ], ["4:00 am", ], ["4:30 am", ], ["5:00 am", ], ["5:30 am", ], ["6:00 am", ], ["6:30 am", ], ["7:00 am", ], ["7:30 am", ], ["8:00 am", ], ["8:30 am", ], ["9:00 am", ], ["9:30 am", ], ["10:00 am", ], ["10:30 am", ], ["11:00 am", ], ["11:30 am", ], ["12:00 pm", ], ["12:30 pm", ], ["1:00 pm", ], ["1:30 pm", ], ["2:00 pm", ], ["2:30 pm", ], ["3:00 pm", ], ["3:30 pm", ], ["4:00 pm", ], ["4:30 pm", ], ["5:00 pm", ], ["5:30 pm", ], ["6:00 pm", ], ["6:30 pm", ], ["7:00 pm", ], ["7:30 pm", ], ["8:00 pm", ], ["8:30 pm", ], ["9:00 pm", ], ["9:30 pm", ], ["10:00 pm", ], ["10:30 pm", ], ["11:00 pm", ], ["11:30 pm"]

  #### PUBLIC METHODS ####
  def check_time_is_future
    self.errors.add :start_time, "must be in the future" unless !self.start_time.nil? and self.start_time.future?
  end

  # Parses an event's time and returns it as an array of Datetime objects
  # "year-month-day hour-minute"
  # This is in 24-hour time, separated by a %
  # "year-month-day hour-minute%year-month-day hour-minute"
  def get_start_times
    self.start_time.split('%').each do |t|
      DateTime.strptime(t, '%Y-%m-%d %H:%M')
    end
  end

  # ** NOT YET WORKING LOL ** #
  # Return differently formatted dates based on how far in advance it is.
  # Say it's Monday - events would show up as:
  # Today - Monday @ time
  # Tomorrow - Tomorrow @ time
  # Next 5 days - Day (Wednesday, Thursday) @ time
  # > 5 days - Full date @ time
  #
  # @return [String] strftime'd date
  def abbreviated_date
    self.start_time.future? ? 'In ' + distance_of_time_in_words(Time.now, self.start_time) : time_ago_in_words(self.start_time) + ' ago' 
  end


  # This is a work in progress
  def abbreviated_date_temp
    distance_in_seconds = self.start_time - Time.now
    
    if distance_in_seconds < 0
      return time_ago_in_words(self.start_time) + ' ago'
    end

    case distance_in_seconds
      when 0..86399       then  return self.start_time.strftime("Today at %l:%M %P")
      when 86400..172799  then  return self.start_time.strftime("Tomorrow at %l:%M %P")
      when 172800..432000 then  return self.start_time.strftime("%A at %l:%M %P")
      else return self.start_time.strftime("%A, %B %d, at %l:%M %P")
    end
  end

  # Return a string depending how soon an event is.
  # More will be added later (featured, etc.)
  #
  # @return [String] soon|later
  def flag
    distance_in_seconds = self.start_time - Time.now
    
    case distance_in_seconds
      when 1..86399       then  return "soon"
      when 86399..172800  then  return "later"
      else return ""
    end
  end


  # Internal methods
end
