class RenameFlyerFields < ActiveRecord::Migration
  def self.up
	change_table :events do |t|
		t.rename :image, :flyer
		t.rename :photo_file_name, :flyer_file_name
		t.rename :photo_content_type, :flyer_content_type
		t.rename :photo_file_size, :flyer_file_size
	end
  end

  def self.down
	change_table :events do |t|
		t.rename :flyer, :image
		t.rename :flyer_file_name, :photo_file_name
		t.rename :flyer_content_type, :photo_content_type
		t.rename :flyer_file_size, :photo_file_size
	end
  end
end
