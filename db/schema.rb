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

ActiveRecord::Schema.define(version: 20150326012326) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cidades", force: true do |t|
    t.string   "nome"
    t.integer  "estado_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cidades", ["estado_id"], name: "index_cidades_on_estado_id", using: :btree

  create_table "estados", force: true do |t|
    t.string   "sigla"
    t.string   "nome"
    t.integer  "capital_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "estados", ["capital_id"], name: "index_estados_on_capital_id", using: :btree

  create_table "extend_settings", force: true do |t|
    t.integer  "application_id"
    t.string   "module"
    t.integer  "extend_type_id"
    t.string   "class"
    t.string   "field"
    t.string   "label"
    t.string   "description"
    t.string   "defaultvalue"
    t.string   "options"
    t.integer  "sortorder"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "extend_types", force: true do |t|
    t.string   "key"
    t.string   "controller"
    t.string   "link"
    t.string   "type"
    t.string   "templateOptions"
    t.string   "expressionProperties"
    t.string   "templateurl"
    t.string   "template"
    t.string   "data"
    t.string   "validation"
    t.string   "watcher"
    t.string   "runExpressions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gogopark_addresses", force: true do |t|
    t.string   "size"
    t.string   "address"
    t.integer  "numberhome"
    t.string   "complement"
    t.string   "neighborhood"
    t.string   "postcode"
    t.integer  "cidade_id"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.integer  "gogopark_space_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "amount"
  end

  add_index "gogopark_addresses", ["cidade_id"], name: "index_gogopark_addresses_on_cidade_id", using: :btree
  add_index "gogopark_addresses", ["gogopark_space_id"], name: "index_gogopark_addresses_on_gogopark_space_id", using: :btree

  create_table "gogopark_discounts", force: true do |t|
    t.integer  "platform_group_id"
    t.integer  "users_id"
    t.float    "price"
    t.string   "typediscount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gogopark_discounts", ["platform_group_id"], name: "index_gogopark_discounts_on_platform_group_id", using: :btree
  add_index "gogopark_discounts", ["users_id"], name: "index_gogopark_discounts_on_users_id", using: :btree

  create_table "gogopark_invoices", force: true do |t|
    t.integer  "users_id"
    t.integer  "gogopark_spaceschedule_id"
    t.float    "price"
    t.datetime "dateref"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gogopark_invoices", ["gogopark_spaceschedule_id"], name: "index_gogopark_invoices_on_gogopark_spaceschedule_id", using: :btree
  add_index "gogopark_invoices", ["users_id"], name: "index_gogopark_invoices_on_users_id", using: :btree

  create_table "gogopark_progresses", force: true do |t|
    t.integer  "users_id"
    t.datetime "checkin"
    t.datetime "checkout"
    t.integer  "gogopark_spaceschedule_id"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gogopark_progresses", ["gogopark_spaceschedule_id"], name: "index_gogopark_progresses_on_gogopark_spaceschedule_id", using: :btree
  add_index "gogopark_progresses", ["users_id"], name: "index_gogopark_progresses_on_users_id", using: :btree

  create_table "gogopark_spacefeatures", force: true do |t|
    t.string   "contactphone"
    t.boolean  "scheduleprivacy"
    t.integer  "maxheight"
    t.boolean  "eletricrecharge"
    t.integer  "gogopark_address_id"
    t.string   "others"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gogopark_spacefeatures", ["gogopark_address_id"], name: "index_gogopark_spacefeatures_on_gogopark_address_id", using: :btree

  create_table "gogopark_spaceimages", force: true do |t|
    t.string   "filename"
    t.string   "description"
    t.integer  "gogopark_address_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gogopark_spaceimages", ["gogopark_address_id"], name: "index_gogopark_spaceimages_on_gogopark_address_id", using: :btree

  create_table "gogopark_spaces", force: true do |t|
    t.string   "term"
    t.string   "type"
    t.string   "description"
    t.integer  "amount"
    t.integer  "platform_group_id"
    t.integer  "users_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gogopark_spaces", ["platform_group_id"], name: "index_gogopark_spaces_on_platform_group_id", using: :btree
  add_index "gogopark_spaces", ["users_id"], name: "index_gogopark_spaces_on_users_id", using: :btree

  create_table "gogopark_spaceschedules", force: true do |t|
    t.datetime "dateref"
    t.integer  "dayofweek"
    t.time     "end"
    t.time     "start"
    t.float    "price"
    t.integer  "gogopark_address_id"
    t.integer  "gogopark_discounts_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gogopark_spaceschedules", ["gogopark_address_id"], name: "index_gogopark_spaceschedules_on_gogopark_address_id", using: :btree
  add_index "gogopark_spaceschedules", ["gogopark_discounts_id"], name: "index_gogopark_spaceschedules_on_gogopark_discounts_id", using: :btree

  create_table "gogopark_spaceverifications", force: true do |t|
    t.boolean  "spaceverications"
    t.boolean  "spaceverified"
    t.integer  "users_id"
    t.string   "description"
    t.integer  "gogopark_space_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gogopark_spaceverifications", ["gogopark_space_id"], name: "index_gogopark_spaceverifications_on_gogopark_space_id", using: :btree
  add_index "gogopark_spaceverifications", ["users_id"], name: "index_gogopark_spaceverifications_on_users_id", using: :btree

  create_table "oauth_access_grants", force: true do |t|
    t.integer  "resource_owner_id",              null: false
    t.integer  "application_id",                 null: false
    t.string   "token",                          null: false
    t.integer  "expires_in",                     null: false
    t.string   "redirect_uri",      limit: 2048, null: false
    t.datetime "created_at",                     null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: true do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.string   "redirect_uri", limit: 2048, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "platform_groups", force: true do |t|
    t.string   "name"
    t.integer  "groupdad"
    t.integer  "users_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "platform_groups", ["users_id"], name: "index_platform_groups_on_users_id", using: :btree

  create_table "platform_menu_roles", force: true do |t|
    t.integer  "menu_id"
    t.integer  "role_id"
    t.string   "principalid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "platform_menus", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "href"
    t.integer  "short"
    t.integer  "menudad"
    t.string   "icon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "platform_roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "platform_teams", force: true do |t|
    t.integer  "platform_group_id"
    t.integer  "users_id"
    t.boolean  "default"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "platform_teams", ["platform_group_id"], name: "index_platform_teams_on_platform_group_id", using: :btree
  add_index "platform_teams", ["users_id"], name: "index_platform_teams_on_users_id", using: :btree

  create_table "users", force: true do |t|
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
    t.integer  "roles"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
