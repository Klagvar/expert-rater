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

ActiveRecord::Schema[8.0].define(version: 2025_03_21_160127) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "images", force: :cascade do |t|
    t.string "name"
    t.string "file"
    t.float "ave_value"
    t.bigint "theme_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["theme_id"], name: "index_images_on_theme_id"
  end

  create_table "themes", force: :cascade do |t|
    t.string "name"
    t.integer "qty_items"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_token"
    t.boolean "admin", default: false
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

  create_table "values", force: :cascade do |t|
    t.integer "value"
    t.bigint "user_id", null: false
    t.bigint "image_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["image_id"], name: "index_values_on_image_id"
    t.index ["user_id"], name: "index_values_on_user_id"
  end

  add_foreign_key "images", "themes"
  add_foreign_key "values", "images"
  add_foreign_key "values", "users"
end
