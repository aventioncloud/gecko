module V1
  class AccountAPI < Base
    namespace "account"
    
    desc "Return all Account."
    get '/' do
        apartment!
        guard!
        #binding.pry
        
        AccountShared.joins(:account_invests).where(:users_id => current_user["id"])#.or(AccountShared.where(:platform_groups_id => ))
    end
    
    desc "Create a Account."
    params do
      requires :title, type: String, desc: "Account title."
      requires :banks_id, type: Integer, desc: "Bank id."
      requires :user_id, type: Integer, desc: "User id."
      requires :account, type: Integer, desc: "Number account."
      requires :numberapplication, type: Integer, desc: "Number Application of bank."
      requires :startdate, type: Date, desc: "Start Date Application of bank."
      requires :enddate, type: Date, desc: "End Date Application of bank."
      requires :shortage, type: Date, desc: "Shortage Date Application of bank."
      requires :indexador, type: Float, desc: "Indexador."
      optional :iof, type: Boolean, desc: "IOF?"
      requires :value, type: Float, desc: "Value Application"
    end
    post do
      apartment!
      guard!
      account = AccountInvest.create({title: params[:title], banks_id: params[:title], user_id: params[:user_id], account: params[:account], numberapplication: params[:numberapplication], startdate: params[:startdate], iof: params[:iof], value: params[:value], enddate: params[:enddate], shortage: params[:shortage], indexador: params[:indexador] })
    
      if account.save
        account
      else
        account.errors.full_messages
      end
    end
  end 
end