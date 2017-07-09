class AddUsersToLeadRemarked < ActiveRecord::Migration
  def change
    add_reference :lead_remarkeds, :users, index: true
  end
end
