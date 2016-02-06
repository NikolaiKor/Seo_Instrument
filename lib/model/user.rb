require './lib/export/storage_factory'

class User
  attr_reader :id, :username

  def initialize(id, username, password)
    @id = id
    @username = username
    @password = password
  end

  def self.authenticate(username, password)
    App::StorageFactory.new.get_connector.password_auth(username, password)
  end

  def self.get(id)
    App::StorageFactory.new.get_connector.get_user_by_id(id)
  end
end