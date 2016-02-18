class UsersProducts < ActiveRecord::Base
  belongs_to :users
  has_many :products, foreign_key: "id", :primary_key => "product_id"
end
