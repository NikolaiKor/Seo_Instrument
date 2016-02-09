Warden::Strategies.add(:password) do
  def valid?
    params['user_name'] && params['user_password']
  end

  def authenticate!
    _user = User.authenticate(params['user_name'], params['user_password'])
    _user.nil? ? fail! : success!(_user)
  end
end