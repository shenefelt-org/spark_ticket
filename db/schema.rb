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

ActiveRecord::Schema[8.1].define(version: 2026_05_09_212118) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "app_logs", force: :cascade do |t|
    t.string "agent"
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.string "level"
    t.text "message"
    t.string "method"
    t.string "path"
    t.datetime "updated_at", null: false
    t.boolean "uploaded"
  end

  create_table "teches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "employee_id"
    t.string "first_name"
    t.string "last_name"
    t.string "role"
    t.datetime "updated_at", null: false
  end

  create_table "ticket_assignments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "tech_id"
    t.bigint "ticket_id"
    t.datetime "updated_at", null: false
    t.index ["tech_id"], name: "index_ticket_assignments_on_tech_id"
    t.index ["ticket_id"], name: "index_ticket_assignments_on_ticket_id"
  end

  create_table "ticket_responses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "message"
    t.bigint "tech_id", null: false
    t.bigint "ticket_id", null: false
    t.datetime "updated_at", null: false
    t.index ["tech_id"], name: "index_ticket_responses_on_tech_id"
    t.index ["ticket_id"], name: "index_ticket_responses_on_ticket_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "body"
    t.datetime "created_at", null: false
    t.string "priority"
    t.string "status"
    t.string "subject"
    t.datetime "updated_at", null: false
    t.boolean "uploaded", default: false
  end

  add_foreign_key "ticket_assignments", "teches"
  add_foreign_key "ticket_assignments", "tickets"
  add_foreign_key "ticket_responses", "teches"
  add_foreign_key "ticket_responses", "tickets"
end
