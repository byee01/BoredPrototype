# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110219180351) do

  create_table "affiliations", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name",               :null => false
    t.string   "description",        :null => false
    t.string   "location",           :null => false
    t.datetime "time",               :null => false
    t.string   "flyer"
    t.integer  "pattern"
    t.integer  "user_id",            :null => false
    t.integer  "affiliation_id"
    t.string   "categories",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "flyer_file_name"
    t.string   "flyer_content_type"
    t.integer  "flyer_file_size"
  end

  create_table "users", :force => true do |t|
    t.string   "andrew_id",   :null => false
    t.string   "primary_key", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
