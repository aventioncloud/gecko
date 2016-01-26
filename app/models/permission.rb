class Permission < ActiveRecord::Base
  #attr_accessible :subject_class, :action, :name
  has_and_belongs_to_many :roles
end
