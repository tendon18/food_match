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

ActiveRecord::Schema[7.2].define(version: 2026_09_22_132308) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "group_areas", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.string "area"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_areas_on_group_id"
  end

  create_table "group_avoid_conditions", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.string "condition"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_avoid_conditions_on_group_id"
  end

  create_table "group_genres", force: :cascade do |t|
    t.bigint "group_id"
    t.string "genre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_members", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "user_id"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nickname"
    t.index ["group_id", "nickname"], name: "index_group_members_on_group_id_and_nickname", unique: true
  end

  create_table "groups", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.integer "budget"
    t.string "invite_token"
    t.bigint "decided_restaurant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "participant_condition_areas", force: :cascade do |t|
    t.bigint "participant_condition_id", null: false
    t.bigint "group_area_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_area_id"], name: "index_participant_condition_areas_on_group_area_id"
    t.index ["participant_condition_id"], name: "index_participant_condition_areas_on_participant_condition_id"
  end

  create_table "participant_condition_avoids", force: :cascade do |t|
    t.bigint "participant_condition_id", null: false
    t.bigint "group_avoid_condition_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_avoid_condition_id"], name: "index_participant_condition_avoids_on_group_avoid_condition_id"
    t.index ["participant_condition_id", "group_avoid_condition_id"], name: "idx_on_participant_condition_id_group_avoid_conditi_fc2ce6ceb4", unique: true
    t.index ["participant_condition_id"], name: "index_participant_condition_avoids_on_participant_condition_id"
  end

  create_table "participant_condition_genres", force: :cascade do |t|
    t.bigint "participant_condition_id", null: false
    t.bigint "group_genre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_genre_id"], name: "index_participant_condition_genres_on_group_genre_id"
    t.index ["participant_condition_id"], name: "index_participant_condition_genres_on_participant_condition_id"
  end

  create_table "participant_conditions", force: :cascade do |t|
    t.bigint "group_member_id", null: false
    t.integer "budget"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_member_id"], name: "index_participant_conditions_on_group_member_id"
  end

  create_table "restaurant_avoid_conditions", force: :cascade do |t|
    t.bigint "restaurant_id", null: false
    t.bigint "group_avoid_condition_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_avoid_condition_id"], name: "index_restaurant_avoid_conditions_on_group_avoid_condition_id"
    t.index ["restaurant_id"], name: "index_restaurant_avoid_conditions_on_restaurant_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "added_by_id", null: false
    t.bigint "group_genre_id", null: false
    t.bigint "group_area_id", null: false
    t.string "name", null: false
    t.integer "budget", null: false
    t.string "features"
    t.string "url"
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["added_by_id"], name: "index_restaurants_on_added_by_id"
    t.index ["group_area_id"], name: "index_restaurants_on_group_area_id"
    t.index ["group_genre_id"], name: "index_restaurants_on_group_genre_id"
    t.index ["group_id"], name: "index_restaurants_on_group_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  add_foreign_key "group_areas", "groups"
  add_foreign_key "group_avoid_conditions", "groups"
  add_foreign_key "participant_condition_areas", "group_areas"
  add_foreign_key "participant_condition_areas", "participant_conditions"
  add_foreign_key "participant_condition_avoids", "group_avoid_conditions"
  add_foreign_key "participant_condition_avoids", "participant_conditions"
  add_foreign_key "participant_condition_genres", "group_genres"
  add_foreign_key "participant_condition_genres", "participant_conditions"
  add_foreign_key "participant_conditions", "group_members"
  add_foreign_key "restaurant_avoid_conditions", "group_avoid_conditions"
  add_foreign_key "restaurant_avoid_conditions", "restaurants"
  add_foreign_key "restaurants", "group_areas"
  add_foreign_key "restaurants", "group_genres"
  add_foreign_key "restaurants", "group_members", column: "added_by_id"
  add_foreign_key "restaurants", "groups"
end
