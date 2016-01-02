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

ActiveRecord::Schema.define(version: 20160101203243) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "graphs", force: :cascade do |t|
    t.string   "medid"
    t.string   "name"
    t.integer  "user_id"
    t.string   "firstdate"
    t.string   "datapoints", default: [],              array: true
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "med_dbs", force: :cascade do |t|
    t.string "name"
  end

  create_table "meddb", force: :cascade do |t|
    t.string "name"
  end

  create_table "medications", force: :cascade do |t|
    t.string   "userid"
    t.string   "name"
    t.string   "schedule"
    t.string   "dose"
    t.string   "datapoints", default: [],              array: true
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.string   "selfid"
    t.integer  "accounts"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "encryptedpassw"
    t.boolean  "active"
    t.string   "organization"
    t.string   "role"
    t.string   "fullname"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "notification_time"
    t.string   "interaction_id"
    t.integer  "pill_container"
    t.integer  "pills_left"
    t.string   "last_taken"
    t.string   "auth_token"
  end

end
