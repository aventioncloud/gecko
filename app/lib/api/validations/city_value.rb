class City < Grape::Validations::Validator
  def validate_param!(attr_name, params)
    if !Cidade.exists?(params[attr_name])
        raise Grape::Exceptions::Validation, param: @scope.full_name(attr_name), message: "city ID is invalid"
    end
  end
end