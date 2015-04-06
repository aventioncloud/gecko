class AddAttachmentImageToGogoparkSpaceimages < ActiveRecord::Migration
  def self.up
    change_table :gogopark_spaceimages do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :gogopark_spaceimages, :image
  end
end
