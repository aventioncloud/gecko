class Deletrolevalid < Grape::Validations::Validator
  def validate_param!(attr_name, params)
    if User.exists?(:roles => params[attr_name])
        raise Grape::Exceptions::Validation, param: @scope.full_name(attr_name), message: "remove all users to remove role."
    end
  end
end