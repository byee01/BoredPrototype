class MakeActiveDefaultEvents < ActiveRecord::Migration
  def self.up
	change_column :events, :active, :boolean, :default=> false
  end

  def self.down
	change_column :events, :active, :boolean
  end
end
