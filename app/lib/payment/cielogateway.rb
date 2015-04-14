module GogoParkLib
    class CieloGateWay
        def transaction!(token, bandeira, portador, codigoseguranca, valor)
            transaction = Cielo::Transaction.new
            
            valorstr = valor.to_s.sub! '.', ','
            
            #binding.pry
            
            transaction_parameters = {
                                      numero: "1111",
                                      valor: valorstr,
                                      moeda: "986",
                                      bandeira: bandeira,
                                      token: token,
                                      cartao_seguranca: codigoseguranca,
                                      parcelas: 1,
                                      #cartao_portador: portador,
                                      autorizar: 3, # Quando a transação usa token, a tag 'autorizar' precisa ser 3 ou 4
                                      :'url-retorno' => 'http://dokkuapp.com:3001'
                                    }
            
            @create = transaction.create!(transaction_parameters, :store) #inicia uma nova transação
        end
    end
end