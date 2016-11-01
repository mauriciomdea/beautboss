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

ActiveRecord::Schema.define(version: 20161101004140) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 191
    t.text     "body",          limit: 65535
    t.string   "resource_id",   limit: 191,   null: false
    t.string   "resource_type", limit: 191,   null: false
    t.integer  "author_id",     limit: 4
    t.string   "author_type",   limit: 191
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "activities", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.integer  "subject_id",   limit: 4
    t.string   "subject_type", limit: 191
    t.boolean  "read",                     default: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "actor_id",     limit: 4
  end

  add_index "activities", ["user_id", "subject_id", "subject_type"], name: "index_activities_on_user_id_and_subject_id_and_subject_type", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 191, default: "", null: false
    t.string   "encrypted_password",     limit: 191, default: "", null: false
    t.string   "reset_password_token",   limit: 191
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 191
    t.string   "last_sign_in_ip",        limit: 191
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  create_table "blocks", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "troll_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "blocks", ["troll_id"], name: "index_blocks_on_troll_id", using: :btree
  add_index "blocks", ["user_id", "troll_id"], name: "index_blocks_on_user_id_and_troll_id", unique: true, using: :btree
  add_index "blocks", ["user_id"], name: "index_blocks_on_user_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 191
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text     "comment",    limit: 65535
    t.integer  "post_id",    limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "devices", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "platform",   limit: 4
    t.text     "endpoint",   limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "sender_id",  limit: 4
    t.text     "message",    limit: 65535
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "read",                     default: false
    t.boolean  "blocked",                  default: false
  end

  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "places", force: :cascade do |t|
    t.string   "name",          limit: 191
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.float    "latitude",      limit: 24
    t.float    "longitude",     limit: 24
    t.string   "address",       limit: 191
    t.string   "foursquare_id", limit: 191
    t.string   "contact",       limit: 191
    t.string   "website",       limit: 191
  end

  add_index "places", ["foursquare_id"], name: "index_places_on_foursquare_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.text     "image",      limit: 65535
    t.string   "service",    limit: 191
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "place_id",   limit: 4
    t.integer  "category",   limit: 4
    t.float    "latitude",   limit: 24
    t.float    "longitude",  limit: 24
    t.integer  "wows_count", limit: 4,     default: 0
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

  create_table "reports", force: :cascade do |t|
    t.integer  "post_id",     limit: 4
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "flag",        limit: 4
    t.string   "explanation", limit: 191
  end

  add_index "reports", ["post_id"], name: "index_reports_on_post_id", using: :btree
  add_index "reports", ["user_id"], name: "index_reports_on_user_id", using: :btree

  create_table "temporary_passwords", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "password",   limit: 191
    t.date     "expire_at"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "temporary_passwords", ["user_id"], name: "index_temporary_passwords_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                limit: 191
    t.string   "email",               limit: 191
    t.string   "password_digest",     limit: 191
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.text     "avatar",              limit: 65535
    t.string   "website",             limit: 191
    t.string   "location",            limit: 191
    t.text     "bio",                 limit: 65535
    t.string   "instagram",           limit: 191
    t.string   "facebook",            limit: 191
    t.string   "swarm",               limit: 191
    t.boolean  "notify_new_follower"
    t.boolean  "notify_new_comment"
    t.boolean  "notify_new_wow"
    t.string   "username",            limit: 191
    t.string   "language",            limit: 191,   default: "en-US"
  end

  add_index "users", ["username"], name: "index_users_on_username", using: :btree

  create_table "wows", force: :cascade do |t|
    t.integer  "post_id",    limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "wows", ["post_id"], name: "index_wows_on_post_id", using: :btree
  add_index "wows", ["user_id"], name: "index_wows_on_user_id", using: :btree

end
