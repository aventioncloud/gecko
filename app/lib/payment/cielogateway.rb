module GogoParkLib
    class CieloGateWay
        def transaction!(token, crypted_number, users_id, bandeira, portador, codigoseguranca, valor, cardaddress, city, zip)
            
            #save creditcard
            creditcard = GogopayCreditcard.where({token: token}).first
            
            #Verifica se o cartão existe, se não existir ele armazena o novo.
            if creditcard == nil
            
                creditcard = GogopayCreditcard.create({
                    users_id: users_id,
                    name: portador,
                    crypted_number: crypted_number,
                    token: token,
                    card_type: bandeira,
                    street_address: cardaddress,
                    city: city,
                    zip: zip
                })
                
            end
            
            transac = GogopayTransaction.create({
                users_id: users_id,
                gogopay_creditcards_id: creditcard.id,
                tid: nil
            })
            
            #Inicia a transação com a Cielo
            transaction = Cielo::Transaction.new
            
            transaction_parameters = {
                                      numero: transac.id,
                                      valor: valor,
                                      moeda: "986",
                                      bandeira: bandeira,
                                      token: token,
                                      cartao_seguranca: codigoseguranca,
                                      parcelas: 1,
                                      autorizar: 3,
                                      :'url-retorno' => 'https://gogopark.com.br'
                                    }
            
            @create = transaction.create!(transaction_parameters, :store) #inicia uma nova transação
            
            GogopayTransaction.find(transac.id).update({
                tid: @create[:"transacao"][:"tid"]
            })
            GogopayTransaction.find(transac.id)
        end
        
        def verify!(tid)
            transaction = Cielo::Transaction.new
            @transac = transaction.verify!(tid) #verifica o status de uma transação
            
            if @transac[:"erro"] != nil
                @transac[:"erro"]
            else
                @transac[:"transacao"][:autorizacao]
            end
        end
    end
end