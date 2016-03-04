class AddLeadToLeadHistory < ActiveRecord::Migration
  def change
    add_reference :lead_histories, :lead, index: true
  end
end
