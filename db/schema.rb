# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090621191148) do

  create_table "books", :force => true do |t|
    t.string   "title",                                      :null => false
    t.decimal  "price",       :precision => 10, :scale => 2, :null => false
    t.string   "author",                                     :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_items", :force => true do |t|
    t.integer  "order_id",                         :null => false
    t.integer  "product_id",                       :null => false
    t.string   "product_type", :default => "Book"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id",                             :null => false
    t.string   "order_type",  :default => "purchase", :null => false
    t.boolean  "refunded",    :default => false,      :null => false
    t.string   "purchase_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.datetime "expires_at",                                                  :null => false
    t.integer  "times_renewed",                                :default => 0, :null => false
    t.decimal  "price",         :precision => 10, :scale => 2,                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username",                      :null => false
    t.string   "email",                         :null => false
    t.string   "password",                      :null => false
    t.string   "real_name"
    t.boolean  "is_admin",   :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
