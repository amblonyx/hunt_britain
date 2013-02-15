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

ActiveRecord::Schema.define(:version => 20130214174053) do

  create_table "hunts", :force => true do |t|
    t.integer  "product_id"
    t.string   "voucher_code"
    t.string   "team_name"
    t.string   "email"
    t.boolean  "started"
    t.boolean  "paused"
    t.boolean  "completed"
    t.datetime "started_at"
    t.datetime "last_submitted"
    t.integer  "current_clue"
    t.string   "current_status"
    t.integer  "time_taken"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "user_id"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "hunt_mode"
    t.string   "image"
    t.string   "region"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "data_file"
  end

  create_table "products", :force => true do |t|
    t.string   "product_code"
    t.string   "name"
    t.string   "format"
    t.float    "price"
    t.string   "data_file"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "location_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token", :unique => true

end
