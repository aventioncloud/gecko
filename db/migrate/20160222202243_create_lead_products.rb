class CreateLeadProducts < ActiveRecord::Migration
  def change
    create_table :lead_products do |t|
      t.integer :product_id
      t.integer :lead_id

      t.timestamps
    end
  end
end
