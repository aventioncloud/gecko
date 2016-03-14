class AddQueueAtToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :queue_at, :datetime
  end
end
