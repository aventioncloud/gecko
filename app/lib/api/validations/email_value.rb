class Email < Grape::Validations::Validator
  def validate_param!(attr_name, params)
    if User.exists?(:email => params[attr_name])
        raise Grape::Exceptions::Validation, param: @scope.full_name(attr_name), message: "exists in base."
    end
  end
end