require 'data_mapper'

module DataMapperExport
  class User
    include DataMapper::Resource
    storage_names[:default] = 'users'

    property :id, Serial
    property :username, String
    property :password, String
  end
end