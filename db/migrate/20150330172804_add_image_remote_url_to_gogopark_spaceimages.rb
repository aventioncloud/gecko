class AddImageRemoteUrlToGogoparkSpaceimages < ActiveRecord::Migration
  def change
    add_column :gogopark_spaceimages, :image_remote_url, :string
  end
end
