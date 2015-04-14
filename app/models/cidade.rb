class Cidade < ActiveRecord::Base
  belongs_to :estado
  has_many :gogopark_address
  
  #has_and_belongs_to_many :gogopark_address

  #def cidade_params
  #  params.require(:cidade).permit(:nome)
  #end
end