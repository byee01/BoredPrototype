class AddMockUser < ActiveRecord::Migration
  def self.up
	e = User.new
	e.andrew_id = "vrp"
	e.save!
  end

  def self.down
	e = User.find_by_andrew_id("vrp")
	e.destroy!
  end
end
