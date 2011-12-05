# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20110911205737) do

  create_table "events", :force => true do |t|
    t.string   "name",                                                  :null => false
    t.text     "description",                                           :null => false
    t.string   "location",                                              :null => false
    t.string   "start_time",                                            :null => false
    t.string   "end_time",                                              :null => false
    t.datetime "event_start",        :default => '2011-12-05 00:36:29', :null => false
    t.datetime "event_end",          :default => '2011-12-05 00:36:29', :null => false
    t.string   "flyer"
    t.integer  "pattern"
    t.string   "categories"
    t.integer  "approval_rating",    :default => 100
    t.string   "approver_id"
    t.string   "flyer_file_name"
    t.string   "flyer_content_type"
    t.integer  "flyer_file_size"
    t.datetime "flyer_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
