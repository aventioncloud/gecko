class Group < ActiveRecord::Base
  belongs_to :users
  
  before_create :record_active
  
  def self.all_children(children_array, groups_id)
    children = Group.where(:dadgroup => groups_id) rescue nil
    #binding.pry
    if children != nil
      aryitem = Group.where(:id => groups_id)
      #aryitem = children#Lead.joins(:user).select('leads.id').where('users.groups_id = ?', groups_id) rescue nil
      
      if aryitem.exists?
        children_array << aryitem
      end
      children.each do |child|
        Group.all_children(children_array, child.id)
      end
    else
      children_array << Group.where(:id => groups_id)
    end
    children_array.flatten!
    children_array
  end
  
  
  private
    def record_active
      self.active = 'S'
    end
end
