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

ActiveRecord::Schema.define(:version => 20110408212510) do

  create_table "comics", :force => true do |t|
    t.string   "name"
    t.string   "base_url",           :default => "http://"
    t.string   "method"
    t.string   "search_type"
    t.string   "search_query"
    t.string   "url_scheme"
    t.string   "directory"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "regexp_search"
    t.string   "regexp_replace"
    t.string   "status",             :default => "enabled"
    t.string   "last_error_message"
    t.datetime "last_error_at"
    t.integer  "error_count",        :default => 0,         :null => false
    t.boolean  "ignore_size",        :default => false
  end

  add_index "comics", ["name"], :name => "index_comics_on_name"

  create_table "strips", :force => true do |t|
    t.integer  "comic_id"
    t.datetime "date"
    t.string   "url"
    t.string   "hash_value"
    t.string   "title_tag"
    t.string   "alt_tag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bytes"
    t.string   "filename"
  end

  add_index "strips", ["comic_id"], :name => "index_strips_on_comic_id"
  add_index "strips", ["date"], :name => "index_strips_on_date"
  add_index "strips", ["hash_value"], :name => "index_strips_on_hash_value"

end
