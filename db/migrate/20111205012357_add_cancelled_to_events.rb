class AddCancelledToEvents < ActiveRecord::Migration
  def change
    add_column :events, :cancelled, :boolean, :default => false
  end
end
