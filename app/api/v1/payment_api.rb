module V1
  class PaymentAPI < Base
    require_relative '../../lib/api/validations/minimum_value'
    require_relative '../../lib/api/validations/creditcard_value'
    require_relative '../../lib/api/validations/city_value'
    require_relative '../../lib/payment/cielogateway'
    namespace "payment"
    
      desc "Process Payment."
      params do
        requires :cardbanner, type: String, values: ['visa', 'mastercard', 'amex'], desc: "CreditCard Banner"
        requires :cardnumber, type: String, credit_card: true, desc: "CreditCard Number."
        requires :cardname, type: String, desc: "CreditCard Name."
        requires :cardmount, type: Integer, regexp: /^([1-9]|1[0-2])$/, desc: "CreditCard Mount Date Validate."
        requires :cardyear, type: Integer, regexp: /^\d{4}$/, desc: "CreditCard Year Date Validate."
        requires :cardsecurity, type: String, regexp: /^[0-9]{3,4}$/, desc: "CreditCard Security Number."
        requires :cardaddress, type: String, desc: "Endereço do Cartão de Credito."
        requires :city, type: Integer, city: true, desc: "City ID"
        requires :zip, type: String, desc: "Zip Code."
        requires :amount, type: Integer, regexp: /^[0-9]+$/, desc: "Amount."
        requires :urlretorno, regexp: /^(http|https)/, type: String, desc: "URL Return."
      end
      post do
        guard!
        #Cria o Token baseado no numero do cartão de credito
        token_request = Cielo::Token.new
        token_parameters = {
          :cartao_numero => params[:cardnumber],  
          :cartao_validade => params[:cardyear] + params[:cardmount], 
          :cartao_portador => params[:cardname]
        }
        
        response = token_request.create! token_parameters, :store
        #response
        
        #recupera o token
        token = response[:"retorno-token"][:token][:"dados-token"][:"codigo-token"]
        crypted_number = response[:"retorno-token"][:token][:"dados-token"][:"numero-cartao-truncado"]
        
        cielo = GogoParkLib::CieloGateWay.new
        @transaction = cielo.transaction!(token, crypted_number, current_user["id"], params[:cardbanner], params[:cardname], params[:cardsecurity], params[:amount], params[:cardaddress], params[:city], params[:zip])
        
        @ary = { tid: @transaction.tid, crypted_number: crypted_number, createat: @transaction.created_at,  cardname: params[:cardname], cardbanner: params[:cardbanner]}
        @ary
        
      end
      
      desc "Verify transaction."
      params do
        requires :tid, type: String, desc: "TID Code."
      end
      post "verify" do
        guard!
        cielo = GogoParkLib::CieloGateWay.new
        @verify = cielo.verify!(params[:tid])
        @verify
      end
  end
end