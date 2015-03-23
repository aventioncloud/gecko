module UserHelper
  def fetch_users
    users =  $redis.get("users")
    if users.nil?
      users = User.all.to_json
      $redis.set("users", users)
      #$redis.expire("categories",3.hour.to_i)
    end
    @users = JSON.load users
  end
end