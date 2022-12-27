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

ActiveRecord::Schema[7.0].define(version: 2022_12_18_131333) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", id: :serial, force: :cascade do |t|
    t.string "type_account", limit: 1
    t.string "currency", limit: 3
    t.decimal "initial_balance", precision: 10, scale: 2, default: "0.0"
    t.decimal "current_balance", precision: 10, scale: 2, default: "0.0"
    t.integer "broker_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id"
    t.index ["broker_id"], name: "index_accounts_on_broker_id"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "brokers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_brokers_on_user_id"
  end

  create_table "strategies", force: :cascade do |t|
    t.string "name"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_strategies_on_user_id"
  end

  create_table "trades", id: :serial, force: :cascade do |t|
    t.decimal "value", precision: 10, scale: 2
    t.decimal "profit", precision: 10, scale: 2
    t.boolean "result"
    t.decimal "result_balance", precision: 10, scale: 2
    t.integer "account_id"
    t.integer "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "type_trade", limit: 1, default: "T"
    t.bigint "strategy_id"
    t.index ["account_id"], name: "index_trades_on_account_id"
    t.index ["strategy_id"], name: "index_trades_on_strategy_id"
    t.index ["user_id"], name: "index_trades_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at", precision: nil
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.string "name"
    t.string "email"
    t.integer "risk"
    t.text "tokens"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "accounts", "brokers"
  add_foreign_key "accounts", "users"
  add_foreign_key "brokers", "users"
  add_foreign_key "strategies", "users"
  add_foreign_key "trades", "accounts"
  add_foreign_key "trades", "strategies"
  add_foreign_key "trades", "users"
end
