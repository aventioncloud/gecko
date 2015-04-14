Cielo.setup do |config|
  config.environment = :test #:production
  config.numero_afiliacao = "1006993069" # fornecido pela cielo
  config.chave_acesso = "25fbb99741c739dd84d7b06ec78c9bac718838630f30b112d033ce2e621b34f3" # fornecido pela cielo
  config.return_path = "http://path/to" # URL para onde a cielo redirecionara seu usuário após inserir os dados na cielo.
end