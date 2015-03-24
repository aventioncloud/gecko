class Cidade < ActiveRecord::Base
  belongs_to :estado

  def cidade_params
    params.require(:cidade).permit(:nome)
  end
end