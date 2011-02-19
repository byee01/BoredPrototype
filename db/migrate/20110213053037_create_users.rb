class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :andrew_id, :primary_key, :null=>false

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
