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

ActiveRecord::Schema[8.0].define(version: 2024_11_20_170623) do
  create_table "board_views", force: :cascade do |t|
    t.integer "x"
    t.integer "y"
    t.integer "width"
    t.integer "height"
    t.integer "board_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_board_views_on_board_id"
  end

  create_table "boards", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "width"
    t.integer "height"
    t.integer "total_mines"
    t.integer "generated_mines", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mines", force: :cascade do |t|
    t.integer "x"
    t.integer "y"
    t.integer "board_view_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_view_id"], name: "index_mines_on_board_view_id"
  end

  add_foreign_key "board_views", "boards"
  add_foreign_key "mines", "board_views"
end
