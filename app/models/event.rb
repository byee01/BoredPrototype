include ActionView::Helpers::DateHelper

class Event < ActiveRecord::Base
  validates_presence_of :name, :description, :location, :time, :categories
  validates_size_of :name, :maximum => 35
  validates_size_of :location, :maximum => 100
  validates_format_of :name, :description, :location, :with => /^[a-zA-Z0-9 !.,#\*<>@&:"$\-\\\/']*$/
  validate :check_time_is_future


  #### SCOPES ####
  scope :all, order("time ASC")
  scope :upcoming, where("time >= ?", Time.now)


  #### PUBLIC METHODS ####
  def check_time_is_future
    self.errors.add :time, "must be in the future" unless !self.time.nil? and self.time.future?
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
    self.time.future? ? 'In ' + distance_of_time_in_words(Time.now, self.time) : time_ago_in_words(self.time) + ' ago' 
  end


  # This is a work in progress
  def abbreviated_date_temp
    distance_in_seconds = self.time - Time.now
    
    if distance_in_seconds < 0
      return time_ago_in_words(self.time) + ' ago'
    end

    case distance_in_seconds
      when 0..86399       then  return self.time.strftime("Today at %l:%M %P")
      when 86400..172799  then  return self.time.strftime("Tomorrow at %l:%M %P")
      when 172800..432000 then  return self.time.strftime("%A at %l:%M %P")
      else return self.time.strftime("%A, %B %d, at %l:%M %P")
    end
  end

  # Return a string depending how soon an event is.
  # More will be added later (featured, etc.)
  #
  # @return [String] soon|later
  def flag
    distance_in_seconds = self.time - Time.now
    
    case distance_in_seconds
      when 1..86399       then  return "soon"
      when 86399..172800  then  return "later"
      else return ""
    end
  end


  # Internal methods
end
