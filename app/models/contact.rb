class Contact < ActiveRecord::Base

  belongs_to :lead

  after_create :record_webservice

  private
    def record_active
      self.active = 'S'
    end

    def record_webservice
      self.active = 'S'

      require 'savon'
      require 'nori'
      binding.pry
      # create a client for the service
      client = Savon.client(wsdl: 'http://consulta.confirmeonline.com.br/Integracao/Consulta?wsdl')

      #client.operations
      # => [:find_user, :list_users]

      # call the 'findUser' operation
      response = client.call(:telefone, message: { usuario: 'INTUNICO', password: '7xnus2BX', sigla: 'ATURJ', telefone: self.phone })

      
      # => { find_user_response: { id: 42, name: 'Hoff' } }
      parser = Nori.new
      my_hash = parser.parse(response.body[:telefone_response][:return])

      endereco = my_hash['RESULTADO']['REGISTRO']['ENDERECO']+','+my_hash['RESULTADO']['REGISTRO']['NUMERO']+' '+my_hash['RESULTADO']['REGISTRO']['COMPLEMENTO']+','+my_hash['RESULTADO']['REGISTRO']['BAIRRO']+','+my_hash['RESULTADO']['REGISTRO']['CIDADE']+'-'+my_hash['RESULTADO']['REGISTRO']['UF']

      Contactjob.create(contact_id: self.id, nome: my_hash['RESULTADO']['REGISTRO']['NOME']).save
  end
end
