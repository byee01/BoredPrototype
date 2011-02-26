class ChangeDescriptionSize < ActiveRecord::Migration
  def self.up
	change_table :events do |t|
		t.change :description, :text
	end
  end

  def self.down
  end
end
