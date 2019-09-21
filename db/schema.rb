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

ActiveRecord::Schema.define(version: 2019_09_21_180757) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "kids", force: :cascade do |t|
    t.string "name"
    t.string "grade"
    t.string "group"
    t.string "family_key"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "campus"
    t.string "father_last_name"
    t.string "mother_last_name"
    t.string "student_id"
    t.string "full_name"
  end

  create_table "kids_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "kid_id", null: false
    t.index ["user_id", "kid_id"], name: "index_kids_users_on_user_id_and_kid_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "title", null: false
    t.string "description"
    t.datetime "publication_date", default: "2019-09-15 00:01:56", null: false
    t.string "role"
    t.string "relationship"
    t.string "campus"
    t.string "grade"
    t.string "group"
    t.string "family_key"
    t.string "student_name"
    t.boolean "seen", default: false
    t.string "category"
    t.boolean "assist", default: false
    t.integer "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: 6
    t.datetime "remember_created_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "authentication_token", limit: 30
    t.string "name"
    t.string "role"
    t.string "family_key"
    t.string "relationship"
    t.string "admin_campus"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "notifications", "users"
end
