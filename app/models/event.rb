include ActionView::Helpers::DateHelper

class Event < ActiveRecord::Base
  validates_presence_of :name, :description, :location, :start_time, :end_time, :categories, :approval_rating, :event_start, :event_end
  validates_size_of :location, :maximum => 100
  ### validates_format_of :name, :location, :with => /^[a-zA-Z0-9 !.,#\*<>@&:"$\-\\\/']*$/

  before_save :add_event_times

  before_validation :check_empty_dates
 


  #### SCOPES ####
  scope :all, order("start_time ASC")
  scope :upcoming, where("start_time >= ?", Time.now)
  scope :approved, where("approval_rating = ?", 100)
  scope :awaiting_approval, where("approval_rating = ?", 0)
  scope :approved_upcoming, where("start_time >= ?", Time.now).where("approval_rating = ?", 100)


  #### PAPERCLIP ####
  has_attached_file :flyer

  #### DATA ####
  EVENT_TIMES = ["12:00 am", "00:00"], ["12:30 am", "00:30"], ["1:00 am", "1:00"], ["1:30 am", "1:30"], ["2:00 am", "2:00"], ["2:30 am", "2:30"], ["3:00 am", "3:00"], ["3:30 am", "3:30"], ["4:00 am", "4:00"], ["4:30 am", "4:30"], ["5:00 am", "5:00"], ["5:30 am", "5:30"], ["6:00 am", "6:00"], ["6:30 am", "6:30"], ["7:00 am", "7:00"], ["7:30 am", "7:30"], ["8:00 am", "8:00"], ["8:30 am", "8:30"], ["9:00 am", "9:00"], ["9:30 am", "9:30"], ["10:00 am", "10:00"], ["10:30 am", "10:30"], ["11:00 am", "11:00"], ["11:30 am", "11:30"], ["12:00 pm", "12:00"], ["12:30 pm", "12:30"], ["1:00 pm", "13:00"], ["1:30 pm", "13:30"], ["2:00 pm", "14:00"], ["2:30 pm", "14:30"], ["3:00 pm", "15:00"], ["3:30 pm", "15:30"], ["4:00 pm", "16:00"], ["4:30 pm", "16:30"], ["5:00 pm", "17:00"], ["5:30 pm", "17:30"], ["6:00 pm", "18:00"], ["6:30 pm", "18:30"], ["7:00 pm", "19:00"], ["7:30 pm", "19:30"], ["8:00 pm", "20:00"], ["8:30 pm", "20:30"], ["9:00 pm", "21:00"], ["9:30 pm", "21:30"], ["10:00 pm", "22:00"], ["10:30 pm", "22:30"], ["11:00 pm", "23:00"], ["11:30 pm", "23:30"]
  EVENT_CATEGORIES = %w(Arts Sports Professional Cultural Music Movies Academic Social Service)

  #### PUBLIC METHODS ####

  # Parses an event's time and returns it as an array of Datetime objects
  # "year-month-day hour-minute"
  # This is in 24-hour time, separated by a %
  # "year-month-day hour-minute%year-month-day hour-minute"
  def get_start_times
    times = []
    self.start_time.split('%').each do |t|
      times.push(DateTime.strptime(t, '%m-%d-%Y %H:%M'))
    end
    times
  end

  def get_end_times
    times = []
    self.end_time.split('%').each do |t|
      times.push(DateTime.strptime(t, '%m-%d-%Y %H:%M'))
    end
    times
  end

  def get_datetime_from_time_string(str)
    DateTime.strptime(str, '%Y-%d-%m %H:%M') rescue Time.now
  end


  def merge_times(date, time)
    return "" + date.split('/').reverse.join('-') + " " + time
  end

  def add_event_times
    puts self.start_time
    puts self.end_time
    self.event_start = get_datetime_from_time_string(self.start_time)
    self.event_end = get_datetime_from_time_string(self.end_time)
  end

  def edit_start_date
    if self.start_time.nil?
      return Time.now.strftime('%m/%d/%Y')
    else
      puts "AHHHHHHHHHHHHHHHHH"
      puts self.start_time
      old_date = DateTime.strptime(self.start_time, '%Y-%d-%m %H:%M') rescue Time.now
      old_date.strftime('%m/%d/%Y')
    end
  end

  def edit_end_date
    if self.end_time.nil?
      return Time.now.strftime('%m/%d/%Y')
    else
      puts "AHHHHHHHHHHHHHHHHH"
      puts self.end_time
      old_date = DateTime.strptime(self.end_time, '%Y-%d-%m %H:%M') rescue Time.now
      old_date.strftime('%m/%d/%Y')
    end
  end

  # Approval
  def approve_event
    self.approval_rating = 100
  end

  def decline_event
    self.approval_rating = -1
  end

  private

  def check_empty_dates
    if :start_time_date.empty? or :end_time_date.empty?
      flash[:error] = 'You must give a date'
      errors.add :start_time, :message => "You need to input a date"
      return false
    else
      return true
    end
  end
end
