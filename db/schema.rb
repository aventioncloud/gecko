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

ActiveRecord::Schema.define(version: 20160304142635) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_invests", force: true do |t|
    t.string   "title"
    t.integer  "banks_id"
    t.integer  "account"
    t.integer  "numberapplication"
    t.date     "startdate"
    t.date     "enddate"
    t.date     "shortage"
    t.decimal  "indexador"
    t.boolean  "iof"
    t.decimal  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "users_id"
  end

  add_index "account_invests", ["banks_id"], name: "index_account_invests_on_banks_id", using: :btree
  add_index "account_invests", ["users_id"], name: "index_account_invests_on_users_id", using: :btree

  create_table "account_shareds", force: true do |t|
    t.integer  "account_invests_id"
    t.integer  "users_id"
    t.integer  "platform_groups_id"
    t.boolean  "write"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "account_shareds", ["account_invests_id"], name: "index_account_shareds_on_account_invests_id", using: :btree
  add_index "account_shareds", ["platform_groups_id"], name: "index_account_shareds_on_platform_groups_id", using: :btree
  add_index "account_shareds", ["users_id"], name: "index_account_shareds_on_users_id", using: :btree

  create_table "accounts", force: true do |t|
    t.integer  "owner_id"
    t.string   "subdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "atendimentos", force: true do |t|
    t.integer  "users_id"
    t.string   "ischat"
    t.string   "ispf"
    t.string   "ispj"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "atendimentos", ["users_id"], name: "index_atendimentos_on_users_id", using: :btree

  create_table "banks", force: true do |t|
    t.string   "name"
    t.string   "numberbank"
    t.string   "imagesmall"
    t.string   "imagelarge"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cidades", force: true do |t|
    t.string   "nome"
    t.integer  "estado_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cidades", ["estado_id"], name: "index_cidades_on_estado_id", using: :btree

  create_table "contacts", force: true do |t|
    t.string   "phone"
    t.string   "address"
    t.string   "number"
    t.string   "cpfcnpj"
    t.string   "city"
    t.string   "active"
    t.string   "zipcode"
    t.string   "email"
    t.string   "letter"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "code"
    t.string   "typecontact"
  end

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

  create_table "groups", force: true do |t|
    t.string   "name"
    t.integer  "dadgroup"
    t.integer  "users_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "active"
    t.string   "code"
  end

  add_index "groups", ["users_id"], name: "index_groups_on_users_id", using: :btree

  create_table "import_files", force: true do |t|
    t.string   "docfile_file_name"
    t.string   "docfile_path"
    t.string   "docfile"
    t.string   "status"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lead_files", force: true do |t|
    t.string   "docfile_file_name"
    t.string   "docfile_path"
    t.string   "docfile"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lead_histories", force: true do |t|
    t.integer  "leadstatus_id"
    t.integer  "user_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lead_id"
    t.integer  "lead_file_id"
  end

  add_index "lead_histories", ["lead_id"], name: "index_lead_histories_on_lead_id", using: :btree
  add_index "lead_histories", ["leadstatus_id"], name: "index_lead_histories_on_leadstatus_id", using: :btree
  add_index "lead_histories", ["user_id"], name: "index_lead_histories_on_user_id", using: :btree

  create_table "lead_products", force: true do |t|
    t.integer  "product_id"
    t.integer  "lead_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lead_statuses", force: true do |t|
    t.string   "name"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leads", force: true do |t|
    t.integer  "user_id"
    t.integer  "leadstatus_id"
    t.integer  "contact_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "docfile"
    t.string   "docfile_path"
    t.string   "docfile_file_name"
    t.integer  "numberproduct"
    t.string   "code"
  end

  add_index "leads", ["contact_id"], name: "index_leads_on_contact_id", using: :btree
  add_index "leads", ["leadstatus_id"], name: "index_leads_on_leadstatus_id", using: :btree
  add_index "leads", ["user_id"], name: "index_leads_on_user_id", using: :btree

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

  create_table "permissions", force: true do |t|
    t.string   "subject_class"
    t.string   "action"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions_roles", force: true do |t|
    t.integer "permission_id"
    t.integer "role_id"
  end

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

  create_table "products", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.integer  "accounts_id"
    t.string   "name"
    t.string   "active"
    t.datetime "deleted_at"
    t.integer  "groups_id"
    t.string   "isemail"
    t.string   "islead"
    t.string   "celular"
    t.string   "code"
  end

  add_index "users", ["accounts_id"], name: "index_users_on_accounts_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["groups_id"], name: "index_users_on_groups_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_products", force: true do |t|
    t.integer "user_id"
    t.integer "product_id"
  end

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.string   "ip"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
