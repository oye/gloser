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

ActiveRecord::Schema[7.1].define(version: 2023_12_09_153325) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "levels", force: :cascade do |t|
    t.integer "current_word_id"
    t.boolean "current_word_english"
    t.boolean "current_word_completed"
    t.boolean "current_word_correct"
    t.string "current_word_guess"
    t.integer "options_order", array: true
    t.integer "level_number"
    t.uuid "run_id", null: false
    t.integer "word_ids", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["run_id"], name: "index_levels_on_run_id"
  end

  create_table "runs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "player_name"
    t.integer "score"
    t.integer "week"
    t.integer "current_level_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "year"
  end

  create_table "words", force: :cascade do |t|
    t.string "norwegian", null: false
    t.string "english", null: false
    t.string "wrong_norwegian1", null: false
    t.string "wrong_norwegian2", null: false
    t.string "wrong_norwegian3", null: false
    t.string "wrong_english1", null: false
    t.string "wrong_english2", null: false
    t.string "wrong_english3", null: false
    t.integer "week", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "year"
  end

  add_foreign_key "levels", "runs"
end
