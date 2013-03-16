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

ActiveRecord::Schema.define(:version => 20130303192621) do

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
    t.integer  "price"
    t.string   "data_file"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "location_id"
  end

  create_table "purchase_items", :force => true do |t|
    t.integer  "product_id"
    t.integer  "purchase_id"
    t.integer  "quantity"
    t.integer  "unit_price"
    t.integer  "total_price"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "purchases", :force => true do |t|
    t.datetime "date_purchased"
    t.string   "reference"
    t.integer  "price_total"
    t.integer  "user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
    t.string   "address_1"
    t.string   "address_2"
    t.string   "town"
    t.string   "county"
    t.string   "postcode"
    t.string   "country"
    t.string   "phone"
    t.string   "user_name"
    t.boolean  "guest",           :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token", :unique => true
  add_index "users", ["user_name"], :name => "index_users_on_user_name", :unique => true

end