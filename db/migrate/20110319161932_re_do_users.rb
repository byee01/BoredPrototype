class ReDoUsers < ActiveRecord::Migration
  def self.up
	remove_column :events, :primary_key
  end

  def self.down
	add_column :events, :primary_key, :string, :null=>false
  end
end
