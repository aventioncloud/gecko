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
      #binding.pry
      # create a client for the service
      client = Savon.client(wsdl: 'http://consulta.confirmeonline.com.br/Integracao/Consulta?wsdl')

      #client.operations
      # => [:find_user, :list_users]

      # call the 'findUser' operation
      response = client.call(:completo_whatsapp, message: { usuario: 'INTUNICO', senha: '7xnus2BX', sigla: 'ATURJ', cpfcnpj: '', nome: '', telefone: self.phone })

      
      # => { find_user_response: { id: 42, name: 'Hoff' } }
      parser = Nori.new
      my_hash = parser.parse(response.body[:completo_whatsapp_response][:return])

      #endereco = my_hash['credilink_webservice']['telefone']['endereco']+','+my_hash['credilink_webservice']['telefone']['numero']+' '+my_hash['credilink_webservice']['telefone']['complemento']+','+my_hash['credilink_webservice']['telefone']['bairro']+','+my_hash['credilink_webservice']['telefone']#['cidade']+'-'+my_hash['credilink_webservice']['telefone']['uf']

      #Contactjob.create(contact_id: self.id, nome: my_hash['credilink_webservice']['telefone']['NOME']).save

      Contact.find(self.id).update(xmlpart: response.body[:completo_whatsapp_response][:return])
  end
end
