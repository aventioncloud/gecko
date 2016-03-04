class GroupConverter
  def self.convert(value)
    Group.where(:code => value).exists?
  end
end