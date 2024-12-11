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

ActiveRecord::Schema.define(:version => 20241206012859) do

  create_table "admins", :force => true do |t|
    t.string   "name",            :null => false
    t.string   "email",           :null => false
    t.string   "password_digest", :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true

  create_table "categories", :force => true do |t|
    t.string   "name",          :null => false
    t.text     "description"
    t.integer  "created_by_id", :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "categories", ["name"], :name => "index_categories_on_name", :unique => true

  create_table "clients", :force => true do |t|
    t.string   "name",            :null => false
    t.string   "email",           :null => false
    t.string   "password_digest", :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "clients", ["email"], :name => "index_clients_on_email", :unique => true

  create_table "product_categories", :force => true do |t|
    t.integer  "product_id",  :null => false
    t.integer  "category_id", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "product_categories", ["product_id", "category_id"], :name => "index_product_categories_on_product_id_and_category_id", :unique => true

  create_table "products", :force => true do |t|
    t.string   "name",                                                        :null => false
    t.text     "description"
    t.decimal  "price",         :precision => 10, :scale => 2,                :null => false
    t.integer  "stock",                                        :default => 0, :null => false
    t.integer  "created_by_id",                                               :null => false
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
  end

  create_table "purchases", :force => true do |t|
    t.integer  "client_id",                                                  :null => false
    t.integer  "product_id",                                                 :null => false
    t.integer  "quantity",                                    :default => 1, :null => false
    t.decimal  "total_price",  :precision => 10, :scale => 2,                :null => false
    t.datetime "purchased_at",                                               :null => false
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

end
