class User
  include DataMapper::Resource

  property :id,       Serial
  property :username, String
  property :password, String

  DataMapper.finalize

  def authenticate(attempted_password)
    if self.password == attempted_password
      true
    else
      false
    end
  end
end