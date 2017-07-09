class AddLeadsToLeadRemarked < ActiveRecord::Migration
  def change
    add_reference :lead_remarkeds, :leads, index: true
  end
end
