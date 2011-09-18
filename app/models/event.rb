class Event < ActiveRecord::Base
  validates_presence_of :name, :description, :location, :time, :categories
  validates_size_of :name, :maximum => 35
  validates_size_of :location, :maximum => 100
  validates_format_of :name, :description, :location, :with => /^[a-zA-Z0-9 !.,#\*<>@&:"$\-\\\/']*$/
  validate :check_time_is_future

  scope :all, order("time ASC")
  scope :upcoming, where("time >= ?", Time.now)

  def check_time_is_future
    self.errors.add :time, "must be in the future" unless !self.time.nil? and self.time.future?
  end
end
