class AddActiveToEvents < ActiveRecord::Migration
  def self.up
	add_column :events, :active, :boolean
  end

  def self.down
	remove_column :events, :active
  end
end
