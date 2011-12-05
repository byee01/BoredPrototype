class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string    :name,        :null => false
      t.text      :description, :null => false
      t.string    :location,    :null => false
      t.string    :start_time,  :null => false
      t.string    :end_time,    :null => false
      t.datetime  :event_start, :default => Time.now, :null => false
      t.datetime  :event_end, :default => Time.now, :null => false
      t.string    :flyer
      t.integer   :pattern
      t.string    :categories
      t.integer   :approval_rating, :default => 0
      t.string    :approver_id

      t.string    :flyer_file_name
      t.string    :flyer_content_type
      t.integer   :flyer_file_size
      t.datetime  :flyer_updated_at

      t.timestamps
    end
  end
end
