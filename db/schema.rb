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

ActiveRecord::Schema.define(version: 20160825080112) do

  create_table "links", force: :cascade do |t|
    t.string   "link"
    t.integer  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_links_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "weixin_user_tokens", force: :cascade do |t|
    t.text     "access_token"
    t.integer  "expires_in"
    t.text     "refresh_token"
    t.string   "openid"
    t.string   "scope"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "aid",           default: 1
  end

  create_table "weixin_users", force: :cascade do |t|
    t.string   "openid"
    t.string   "nickname"
    t.integer  "sex"
    t.string   "province"
    t.string   "city"
    t.string   "country"
    t.string   "headimgurl"
    t.text     "privilege"
    t.string   "unionid"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "language"
    t.integer  "weixin_user_token_id"
    t.index ["weixin_user_token_id"], name: "index_weixin_users_on_weixin_user_token_id"
  end

end
