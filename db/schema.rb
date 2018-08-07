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

ActiveRecord::Schema.define(version: 2018_06_09_214452) do

  create_table "affiliation_types", force: :cascade do |t|
    t.boolean "enabled"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "affiliations", force: :cascade do |t|
    t.integer "affiliation_type_id"
    t.boolean "enabled"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["affiliation_type_id"], name: "index_affiliations_on_affiliation_type_id"
  end

  create_table "attendance_records", force: :cascade do |t|
    t.integer "affiliation_id"
    t.integer "meeting_id"
    t.text "who"
    t.text "netid"
    t.integer "when"
    t.integer "status"
    t.boolean "sub"
    t.boolean "late"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["affiliation_id"], name: "index_attendance_records_on_affiliation_id"
    t.index ["meeting_id"], name: "index_attendance_records_on_meeting_id"
  end

  create_table "document_links", force: :cascade do |t|
    t.integer "document_id"
    t.integer "meeting_id"
    t.boolean "voting"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_document_links_on_document_id"
    t.index ["meeting_id"], name: "index_document_links_on_meeting_id"
  end

  create_table "document_types", force: :cascade do |t|
    t.text "name"
    t.boolean "votable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "documents", force: :cascade do |t|
    t.integer "document_type_id"
    t.text "link"
    t.text "name"
    t.boolean "voting_open"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_type_id"], name: "index_documents_on_document_type_id"
  end

  create_table "meetings", force: :cascade do |t|
    t.time "begin"
    t.time "end"
    t.text "name"
    t.text "agenda"
    t.text "minutes"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.text "name"
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "terms", force: :cascade do |t|
    t.text "name"
    t.date "begin"
    t.date "end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer "affiliation_id"
    t.text "netid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
    t.text "name"
  end

  create_table "vote_records", force: :cascade do |t|
    t.integer "affiliation_id"
    t.integer "document_id"
    t.integer "vote"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["affiliation_id"], name: "index_vote_records_on_affiliation_id"
    t.index ["document_id"], name: "index_vote_records_on_document_id"
  end

end
