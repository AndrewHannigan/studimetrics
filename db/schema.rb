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

ActiveRecord::Schema.define(version: 20130705151551) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: true do |t|
    t.string   "name"
    t.string   "publisher"
    t.date     "publish_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "colleges", force: true do |t|
    t.string   "name",             null: false
    t.integer  "critical_reading", null: false
    t.integer  "math",             null: false
    t.integer  "writing",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "free_response_answers", force: true do |t|
    t.string   "value"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "free_response_answers", ["question_id"], name: "index_free_response_answers_on_question_id", using: :btree

  create_table "multiple_choice_answers", force: true do |t|
    t.integer  "question_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "multiple_choice_answers", ["question_id"], name: "index_multiple_choice_answers_on_question_id", using: :btree

  create_table "practice_tests", force: true do |t|
    t.integer  "book_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number",     default: 0, null: false
  end

  add_index "practice_tests", ["book_id"], name: "index_practice_tests_on_book_id", using: :btree

  create_table "questions", force: true do |t|
    t.string   "question_type"
    t.integer  "section_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  add_index "questions", ["section_id"], name: "index_questions_on_section_id", using: :btree

  create_table "range_answers", force: true do |t|
    t.integer  "question_id"
    t.decimal  "min_value"
    t.decimal  "max_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "range_answers", ["question_id"], name: "index_range_answers_on_question_id", using: :btree

  create_table "section_completions", force: true do |t|
    t.integer  "section_id"
    t.string   "status",     default: "In-Progress", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",                            null: false
  end

  add_index "section_completions", ["section_id"], name: "index_section_completions_on_section_id", using: :btree
  add_index "section_completions", ["user_id"], name: "index_section_completions_on_user_id", using: :btree

  create_table "sections", force: true do |t|
    t.integer  "practice_test_id"
    t.integer  "subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number",           default: 0, null: false
  end

  add_index "sections", ["practice_test_id"], name: "index_sections_on_practice_test_id", using: :btree
  add_index "sections", ["subject_id"], name: "index_sections_on_subject_id", using: :btree

  create_table "subjects", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_responses", force: true do |t|
    t.integer  "question_id"
    t.integer  "section_completion_id"
    t.string   "value"
    t.boolean  "correct"
    t.decimal  "time",                  default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_responses", ["question_id"], name: "index_user_responses_on_question_id", using: :btree
  add_index "user_responses", ["section_completion_id"], name: "index_user_responses_on_section_completion_id", using: :btree

  create_table "users", force: true do |t|
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "email",                                          null: false
    t.string   "encrypted_password", limit: 128,                 null: false
    t.string   "confirmation_token", limit: 128
    t.string   "remember_token",     limit: 128,                 null: false
    t.boolean  "admin",                          default: false, null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "city"
    t.string   "state"
    t.string   "grade"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
