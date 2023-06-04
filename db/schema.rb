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

ActiveRecord::Schema[7.0].define(version: 2023_05_30_184245) do
  create_table "device_experiment_values", force: :cascade do |t|
    t.integer "device_token_id", null: false
    t.integer "experiment_id", null: false
    t.string "value"
    t.index ["device_token_id"], name: "index_device_experiment_values_on_device_token_id"
    t.index ["experiment_id"], name: "index_device_experiment_values_on_experiment_id"
  end

  create_table "device_tokens", force: :cascade do |t|
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_device_tokens_on_token", unique: true
  end

  create_table "experiments", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.string "key", null: false
    t.json "options", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_experiments_on_created_at"
  end

  add_foreign_key "device_experiment_values", "device_tokens"
  add_foreign_key "device_experiment_values", "experiments"
end
