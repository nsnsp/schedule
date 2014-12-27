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

ActiveRecord::Schema.define(version: 20141227101951) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "commitments", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "date",                   null: false
    t.string   "type",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commitments", ["date"], name: "index_commitments_on_date", using: :btree
  add_index "commitments", ["type"], name: "index_commitments_on_type", using: :btree
  add_index "commitments", ["user_id"], name: "index_commitments_on_user_id", using: :btree

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "auth0_uid",      limit: 255, null: false
    t.string   "first_name",     limit: 255
    t.string   "last_name",      limit: 255
    t.string   "email",          limit: 255
    t.text     "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "email_verified"
  end

  add_index "identities", ["auth0_uid"], name: "index_identities_on_auth0_uid", unique: true, using: :btree
  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name", limit: 255
    t.string   "last_name",  limit: 255
    t.string   "email",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      limit: 255, null: false
    t.integer  "item_id",                    null: false
    t.string   "event",          limit: 255, null: false
    t.string   "whodunnit",      limit: 255
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
