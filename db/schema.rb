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

ActiveRecord::Schema.define(version: 20160216085347) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.integer "task_id", null: false
    t.integer "user_id", null: false
  end

  create_table "completed_tasks", force: :cascade do |t|
    t.integer  "task_id",      null: false
    t.datetime "completed_at", null: false
  end

  create_table "oauth_credentials", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "oauth_credentials", ["provider", "uid"], name: "index_oauth_credentials_on_provider_and_uid", unique: true, using: :btree

  create_table "personal_tasks", force: :cascade do |t|
    t.integer "task_id", null: false
    t.integer "user_id", null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "task_id", null: false
    t.string  "tag",     null: false
  end

  add_index "taggings", ["tag", "task_id"], name: "index_taggings_on_tag_and_task_id", unique: true, using: :btree

  create_table "task_deadlines", force: :cascade do |t|
    t.integer  "task_id",  null: false
    t.datetime "datetime", null: false
  end

  create_table "task_descriptions", force: :cascade do |t|
    t.integer "task_id", null: false
    t.text    "content", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "title",      null: false
    t.integer  "author_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name",  null: false
    t.string "email", null: false
  end

end
