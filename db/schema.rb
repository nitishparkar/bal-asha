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

ActiveRecord::Schema.define(version: 20141210182451) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "donations", force: true do |t|
    t.datetime "date"
    t.integer  "donor_id"
    t.integer  "type_cd"
    t.decimal  "amount",     precision: 10, scale: 2
    t.decimal  "quantity",   precision: 6,  scale: 2
    t.text     "remarks"
    t.boolean  "deleted",                             default: false, null: false
    t.text     "meta_data"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "donations", ["donor_id"], name: "index_donations_on_donor_id", using: :btree
  add_index "donations", ["person_id"], name: "index_donations_on_person_id", using: :btree

  create_table "donors", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "gender",                       default: 0
    t.date     "date_of_birth"
    t.integer  "donor_type",                   default: 0
    t.integer  "level",                        default: 0
    t.string   "pan_card_no"
    t.string   "trust_no"
    t.string   "mobile"
    t.string   "telephone"
    t.string   "email"
    t.text     "address"
    t.string   "city"
    t.string   "pincode"
    t.string   "state"
    t.boolean  "solicit"
    t.integer  "contact_frequency",            default: 0
    t.integer  "preferred_communication_mode", default: 0
    t.text     "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country_code"
  end

  add_index "donors", ["country_code"], name: "index_donors_on_country_code", using: :btree

  create_table "items", force: true do |t|
    t.string   "name",       default: "",    null: false
    t.text     "remarks"
    t.boolean  "deleted",    default: false, null: false
    t.text     "meta_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "type_cd",                default: 0
  end

  add_index "people", ["email"], name: "index_people_on_email", unique: true, using: :btree
  add_index "people", ["reset_password_token"], name: "index_people_on_reset_password_token", unique: true, using: :btree

end
