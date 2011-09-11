class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string    :name,        :null => false
      t.text      :description, :null => false
      t.string    :location,    :null => false
      t.datetime  :time,        :null => false
      t.string    :flyer
      t.integer   :pattern
      t.string    :categories

      t.timestamps
    end
  end
end
