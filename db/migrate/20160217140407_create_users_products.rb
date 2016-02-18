class CreateUsersProducts < ActiveRecord::Migration
  def up
    create_table :users_products do |t|
      t.integer :user_id
      t.integer :product_id
    end
  end

  def down
    drop_table :users_products
  end
end
