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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150924034848) do

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string   "comment",    limit: 255
    t.integer  "post_id",    limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "places", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "lat",           limit: 255
    t.string   "lon",           limit: 255
    t.string   "address",       limit: 255
    t.string   "foursquare_id", limit: 255
    t.string   "contact",       limit: 255
    t.string   "website",       limit: 255
  end

  add_index "places", ["foursquare_id"], name: "index_places_on_foursquare_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "image",       limit: 255
    t.string   "caption",     limit: 255
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "service_id",  limit: 4
    t.integer  "place_id",    limit: 4
    t.integer  "category_id", limit: 4
  end

  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id", limit: 4
    t.integer  "followed_id", limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "services", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.string   "email",               limit: 255
    t.string   "password_digest",     limit: 255
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "avatar",              limit: 255
    t.string   "website",             limit: 255
    t.string   "location",            limit: 255
    t.string   "bio",                 limit: 255
    t.string   "instagram",           limit: 255
    t.string   "facebook",            limit: 255
    t.string   "swarm",               limit: 255
    t.boolean  "notify_new_follower"
    t.boolean  "notify_new_comment"
    t.boolean  "notify_new_wow"
  end

  create_table "wows", force: :cascade do |t|
    t.integer  "post_id",    limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "wows", ["post_id"], name: "index_wows_on_post_id", using: :btree
  add_index "wows", ["user_id"], name: "index_wows_on_user_id", using: :btree

end
