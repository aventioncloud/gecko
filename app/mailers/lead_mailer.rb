class LeadMailer < ActionMailer::Base
  default from: "noreply@unicoop.com.br"
  
  def created(email)
    #@email = user
    @url  = 'http://example.com/login'
    mail(to: email, subject: 'Nova Cotação Cadastrada')
  end
  
  def created_super(email, name)
    #@email = user
    @name = name
    mail(to: email, subject: 'Nova Cotação Cadastrada')
  end
  
  def prospect(email, frommail,  filename, comment)
    #@email = user
    @url  = 'http://example.com/login'
    @comment = comment
    if filename != nil
      attachments[filename] = File.read(Rails.root.join("public", "docfile/"+filename))
    end
    mail(to: email, from: frommail, subject: 'Proposta Unicoop')
  end
end
