class CreditCard < Grape::Validations::Validator
  def validate_param!(attr_name, params)
    if params[:cardbanner] == 'visa'
        if !params[attr_name].match( /^4[0-9]{12,15}$/ )
          raise Grape::Exceptions::Validation, param: @scope.full_name(attr_name), message: "credit card invalid"
        end
    elsif params[:cardbanner] == 'mastercard'
        if !params[attr_name].match( /^5[1-5]{1}[0-9]{14}$/ )
          raise Grape::Exceptions::Validation, param: @scope.full_name(attr_name), message: "credit card invalid"
        end
    else
        if !params[attr_name].match( /^3(4|7){1}[0-9]{13}$/ )
          raise Grape::Exceptions::Validation, param: @scope.full_name(attr_name), message: "credit card invalid"
        end
    end
  end
end