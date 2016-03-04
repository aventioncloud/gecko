class ChangeColumnHistory < ActiveRecord::Migration
  def up
      change_column :lead_histories, :comment, :text
  end
  def down
      # This might cause trouble if you have strings longer
      # than 255 characters.
      change_column :lead_histories, :comment, :string
  end
end
