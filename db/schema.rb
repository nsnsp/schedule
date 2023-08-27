# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_08_27_044334) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "commitments", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.date "date", null: false
    t.string "type", limit: 255, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "uuid"
    t.index ["date"], name: "index_commitments_on_date"
    t.index ["type"], name: "index_commitments_on_type"
    t.index ["user_id"], name: "index_commitments_on_user_id"
    t.index ["uuid"], name: "index_commitments_on_uuid", unique: true
  end

  create_table "identities", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "auth0_uid", limit: 255, null: false
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.string "email", limit: 255
    t.text "image_url"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "email_verified"
    t.index ["auth0_uid"], name: "index_identities_on_auth0_uid", unique: true
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.string "email", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "suspended", default: false, null: false
    t.integer "roles_mask"
    t.string "phone"
    t.string "auth_token"
    t.boolean "daily_schedule_notification", default: false
    t.boolean "early_schedule_notification", default: false
    t.index ["daily_schedule_notification"], name: "index_users_on_daily_schedule_notification"
    t.index ["early_schedule_notification"], name: "index_users_on_early_schedule_notification"
    t.index ["suspended"], name: "index_users_on_suspended"
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", limit: 255, null: false
    t.integer "item_id", null: false
    t.string "event", limit: 255, null: false
    t.string "whodunnit", limit: 255
    t.text "object"
    t.datetime "created_at", precision: nil
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end