module V1
  class SampleAPI < Base
    namespace "sample"
    authorize_routes!

    get "hello" do
      #guard!
      fetch_users
    end

    get "secret" do
      guard!
      { :secret => "only smart guys can see this ;)" }
    end

    get "top_secret" do
      guard! scopes: [:top_secret]
      { :top_secret => "T0P S3CR37 :p" }
    end

    get "choice_of_sg" do
      guard! scopes: [:el, :psy, :congroo]
      { :says => "El. Psy. Congroo." }
    end
  end
end
