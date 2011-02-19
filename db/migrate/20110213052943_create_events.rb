class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name, :null =>false
      t.string :description, :null => false
      t.string :location, :null => false
      t.datetime :time, :null => false
      t.string :image
      t.integer :pattern
      t.belongs_to  :user, :null => false
	  t.belongs_to :affiliation
      t.string :categories, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
