class Redo2Users < ActiveRecord::Migration
  def self.up
	drop_table :users
	create_table :users  do |t|
      t.string :andrew_id, :null=>false

      t.timestamps
    end
  end

  def self.down
	drop_table :users
	create_table :users do |t|
      t.string :andrew_id, :primary_key, :null=>false

      t.timestamps
    end
  end
end
