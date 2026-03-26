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

ActiveRecord::Schema[8.0].define(version: 2026_03_26_081906) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "ai_suggestions", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "user_id", null: false
    t.bigint "task_id"
    t.integer "kind", default: 0, null: false
    t.text "content", null: false
    t.boolean "applied", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_ai_suggestions_on_company_id"
    t.index ["task_id"], name: "index_ai_suggestions_on_task_id"
    t.index ["user_id"], name: "index_ai_suggestions_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.bigint "user_id", null: false
    t.bigint "company_id", null: false
    t.text "body", null: false
    t.boolean "ai_generated", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_comments_on_company_id"
    t.index ["task_id"], name: "index_comments_on_task_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "industry"
    t.string "logo_url"
    t.string "primary_color", default: "#6366f1"
    t.boolean "active", default: true, null: false
    t.integer "plan", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_companies_on_slug", unique: true
  end

  create_table "notifications", force: :cascade do |t|
    t.string "type", null: false
    t.bigint "recipient_id", null: false
    t.jsonb "params", default: {}, null: false
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id", "read_at"], name: "index_notifications_on_recipient_id_and_read_at"
    t.index ["recipient_id"], name: "index_notifications_on_recipient_id"
  end

  create_table "sectors", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "name", null: false
    t.string "description"
    t.string "color", default: "#6366f1"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "name"], name: "index_sectors_on_company_id_and_name", unique: true
    t.index ["company_id"], name: "index_sectors_on_company_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "sector_id"
    t.bigint "creator_id", null: false
    t.bigint "assignee_id"
    t.bigint "parent_task_id"
    t.string "title", null: false
    t.text "description"
    t.integer "status", default: 0, null: false
    t.integer "priority", default: 1, null: false
    t.date "due_date"
    t.datetime "completed_at"
    t.integer "position", default: 0
    t.integer "ai_priority_score"
    t.text "ai_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignee_id"], name: "index_tasks_on_assignee_id"
    t.index ["company_id"], name: "index_tasks_on_company_id"
    t.index ["creator_id"], name: "index_tasks_on_creator_id"
    t.index ["due_date"], name: "index_tasks_on_due_date"
    t.index ["parent_task_id"], name: "index_tasks_on_parent_task_id"
    t.index ["sector_id"], name: "index_tasks_on_sector_id"
    t.index ["status"], name: "index_tasks_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "phone"
    t.string "avatar_url"
    t.integer "role", default: 0, null: false
    t.boolean "active", default: true, null: false
    t.bigint "company_id"
    t.bigint "sector_id"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["sector_id"], name: "index_users_on_sector_id"
  end

  add_foreign_key "ai_suggestions", "companies"
  add_foreign_key "ai_suggestions", "tasks"
  add_foreign_key "ai_suggestions", "users"
  add_foreign_key "comments", "companies"
  add_foreign_key "comments", "tasks"
  add_foreign_key "comments", "users"
  add_foreign_key "notifications", "users", column: "recipient_id"
  add_foreign_key "sectors", "companies"
  add_foreign_key "tasks", "companies"
  add_foreign_key "tasks", "sectors"
  add_foreign_key "tasks", "tasks", column: "parent_task_id"
  add_foreign_key "tasks", "users", column: "assignee_id"
  add_foreign_key "tasks", "users", column: "creator_id"
  add_foreign_key "users", "companies"
  add_foreign_key "users", "sectors"
end
