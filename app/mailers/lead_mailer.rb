class LeadMailer < ActionMailer::Base
  default from: "naoresponda@unicooprj.com.br"
  
  def created(email, id)
    #@email = user
    @url  = 'http://example.com/login'
    @id = id
    mail(to: email, subject: 'Nova Cotação Cadastrada')
  end
  
  def created_super(email, name, id)
    #@email = user
    @name = name
    @id = id
    mail(to: email, subject: 'Nova Cotação Cadastrada')
  end
  
  def updated(email, _subject, id)
    #@email = user
    @url  = 'http://example.com/login'
    @id = id
    mail(to: email, subject: _subject)
  end
  
  def updated_super(email, name, contato, _subject, id)
    #@email = user
    @name = name
    @id = id
    mail(to: email, subject: _subject)
  end
  
  def prospect(email, frommail,  filename, comment, id)
    #@email = user
    @url  = 'http://example.com/login'
    @id = id
    @comment = comment
    if filename != nil
      attachments[filename] = File.read(Rails.root.join("public", "docfile/"+filename))
    end
    mail(to: email, from: frommail, subject: 'Proposta Unicoop')
  end
end
