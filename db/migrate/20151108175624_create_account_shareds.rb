class CreateAccountShareds < ActiveRecord::Migration
  def change
    create_table :account_shareds do |t|
      t.references :account_invests, index: true
      t.references :users, index: true
      t.references :platform_groups, index: true
      t.boolean :write

      t.timestamps
    end
  end
end
